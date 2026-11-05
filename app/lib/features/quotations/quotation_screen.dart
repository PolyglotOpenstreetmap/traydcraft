import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';

import '../../app/api.dart';
import '../../shared/format.dart';
import '../../shared/search_picker.dart';

/// An editable line of a draft. Prices are never computed here: they come from
/// the server's pricing preview, matched by position.
class _Line {
  _Line(
    this.product, {
    String quantity = '1',
    String discount = '0',
    this.description,
  }) : quantity = TextEditingController(text: quantity),
       discount = TextEditingController(text: discount);

  final Product product;
  final TextEditingController quantity;
  final TextEditingController discount;
  final String? description;

  void dispose() {
    quantity.dispose();
    discount.dispose();
  }
}

/// Create, edit (drafts), view and process a quotation.
class QuotationScreen extends ConsumerStatefulWidget {
  const QuotationScreen({super.key, this.id});

  final String? id;

  @override
  ConsumerState<QuotationScreen> createState() => _QuotationPageState();
}

class _QuotationPageState extends ConsumerState<QuotationScreen> {
  late String? _id = widget.id;
  Quotation? _q;
  Customer? _customer;
  final List<_Line> _lines = [];
  final _notes = TextEditingController();
  PricingPreview? _preview;
  String? _previewError;
  Timer? _debounce;
  int _previewSeq = 0;
  bool _loading = false;
  bool _busy = false;
  String? _error;
  bool _changed = false;

  TraydcraftApi get _api => ref.read(apiProvider);
  bool get _editable => _id == null || _q?.status == QuotationStatus.draft;

  @override
  void initState() {
    super.initState();
    if (_id != null) _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _notes.dispose();
    for (final l in _lines) {
      l.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final q = await _api.sales.getQuotation(id: _id!);
      _apply(q);
      if (q.status == QuotationStatus.draft) {
        final customer = await _api.crm.getCustomer(id: q.customerId);
        final ids = q.lines.map((l) => l.productId).whereType<String>().toSet();
        final products = {
          for (final id in ids) id: await _api.products.getProduct(id: id),
        };
        setState(() {
          _customer = customer;
          for (final l in _lines) {
            l.dispose();
          }
          _lines
            ..clear()
            ..addAll(
              q.lines
                  .where((l) => l.productId != null)
                  .map(
                    (l) => _Line(
                      products[l.productId]!,
                      quantity: number(l.quantity),
                      discount: number(l.lineDiscountPercent),
                      description: l.description,
                    ),
                  ),
            );
          _notes.text = q.notes;
        });
        _refreshPreview();
      }
    } catch (e) {
      setState(() => _error = errorMessage(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _apply(Quotation q) => setState(() {
    _q = q;
    _id = q.id;
    _error = null;
  });

  /// Builds the line inputs; returns null (and sets an error) if a field is invalid.
  List<QuotationLineInput>? _lineInputs() {
    final inputs = <QuotationLineInput>[];
    for (final (i, l) in _lines.indexed) {
      final qty = parseDecimalInput(l.quantity.text);
      final disc = parseDecimalInput(
        l.discount.text.isEmpty ? '0' : l.discount.text,
      );
      if (qty == null || disc == null) {
        _previewError = 'Line ${i + 1}: enter valid numbers.';
        return null;
      }
      inputs.add(
        QuotationLineInput(
          productId: l.product.id,
          quantity: qty,
          lineDiscountPercent: disc,
          description: l.description,
        ),
      );
    }
    return inputs;
  }

  void _onEdited() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), _refreshPreview);
  }

  Future<void> _refreshPreview() async {
    final customer = _customer;
    _previewError = null;
    final inputs = _lineInputs();
    if (customer == null || inputs == null || inputs.isEmpty) {
      setState(() => _preview = null);
      return;
    }
    final seq = ++_previewSeq;
    try {
      final p = await _api.sales.preview(
        body: PricingPreviewInput(customerId: customer.id, lines: inputs),
      );
      if (mounted && seq == _previewSeq) setState(() => _preview = p);
    } catch (e) {
      if (mounted && seq == _previewSeq) {
        setState(() {
          _preview = null;
          _previewError = errorMessage(e);
        });
      }
    }
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
      _changed = true;
    } catch (e) {
      setState(() => _error = errorMessage(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save() => _run(() async {
    final inputs = _lineInputs();
    if (_customer == null || inputs == null || inputs.isEmpty) {
      throw 'Choose a customer and add at least one valid line.';
    }
    final body = QuotationInput(
      customerId: _customer!.id,
      notes: _notes.text,
      lines: inputs,
    );
    final q = _id == null
        ? await _api.sales.createQuotation(body: body)
        : await _api.sales.updateQuotation(id: _id!, body: body);
    _apply(q);
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Saved ${q.number}')));
    }
  });

  Future<void> _transition(Future<Quotation> Function(String id) call) =>
      _run(() async => _apply(await call(_id!)));

  Future<void> _revise() => _run(() async {
    final rev = await _api.sales.reviseQuotation(id: _id!);
    if (mounted) context.pushReplacement('/quotations/${rev.id}');
  });

  Future<void> _pdf() => _run(() async {
    final q = _q!;
    final bytes = await downloadBytes(
      ref.read(dioProvider),
      '/api/v1/quotations/${q.id}/pdf',
    );
    await Printing.layoutPdf(
      name: '${q.number}-r${q.revision}.pdf',
      onLayout: (_) async => Uint8List.fromList(bytes),
    );
  });

  void _close() {
    if (context.canPop()) {
      context.pop(_changed);
    } else {
      context.go('/quotations');
    }
  }

  @override
  Widget build(BuildContext context) {
    final canWrite =
        ref.watch(meProvider).value?.permissions.contains('quotations.write') ??
        false;
    final theme = Theme.of(context);
    final q = _q;
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    IconButton(
                      onPressed: _close,
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Text(
                      q == null
                          ? 'New quotation'
                          : '${q.number}  rev. ${q.revision}',
                      style: theme.textTheme.headlineSmall,
                    ),
                    if (q != null) Chip(label: Text(q.status.json ?? '')),
                    if (_busy)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ..._actions(canWrite),
                  ],
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      _error!,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                const SizedBox(height: 16),
                if (_editable && canWrite)
                  ..._editor(theme)
                else if (q != null)
                  ..._readOnly(q, theme),
              ],
            ),
    );
  }

  List<Widget> _actions(bool canWrite) {
    final q = _q;
    if (!canWrite) {
      return [
        if (q != null)
          OutlinedButton.icon(
            onPressed: _pdf,
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('PDF'),
          ),
      ];
    }
    final s = q?.status;
    return [
      if (_editable)
        FilledButton.icon(
          onPressed: _busy ? null : _save,
          icon: const Icon(Icons.save),
          label: const Text('Save draft'),
        ),
      if (q != null)
        OutlinedButton.icon(
          onPressed: _busy ? null : _pdf,
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text('PDF'),
        ),
      if (s == QuotationStatus.draft)
        OutlinedButton.icon(
          onPressed: _busy
              ? null
              : () => _transition((id) => _api.sales.sendQuotation(id: id)),
          icon: const Icon(Icons.send),
          label: const Text('Mark as sent'),
        ),
      if (s == QuotationStatus.sent) ...[
        OutlinedButton(
          onPressed: _busy
              ? null
              : () => _transition((id) => _api.sales.acceptQuotation(id: id)),
          child: const Text('Accepted'),
        ),
        OutlinedButton(
          onPressed: _busy
              ? null
              : () => _transition((id) => _api.sales.rejectQuotation(id: id)),
          child: const Text('Rejected'),
        ),
      ],
      if (s == QuotationStatus.sent || s == QuotationStatus.rejected)
        OutlinedButton.icon(
          onPressed: _busy ? null : _revise,
          icon: const Icon(Icons.edit_note),
          label: const Text('New revision'),
        ),
    ];
  }

  List<Widget> _editor(ThemeData theme) {
    final preview = _preview;
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SearchPicker<Customer>(
              key: ValueKey(_customer?.id),
              label: 'Customer',
              initial: _customer,
              display: (c) => '${c.code} · ${c.name}',
              search: (q) async =>
                  (await _api.crm.listCustomers(q: q, limit: 20)).items,
              onSelected: (c) {
                setState(() => _customer = c);
                _refreshPreview();
              },
            ),
          ),
          const SizedBox(width: 16),
          if (_customer != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Zone ${_customer!.priceZoneCode ?? '—'} · discount ${number(_customer!.discountPercent ?? '0')} %\n'
                '${_customer!.street}, ${_customer!.postalCode} ${_customer!.city}',
              ),
            ),
        ],
      ),
      const SizedBox(height: 16),
      _linesTable(
        theme,
        rows: [
          for (final (i, l) in _lines.indexed)
            _TableRow(
              code: l.product.code,
              description: l.description ?? l.product.name,
              quantity: _numField(l.quantity, l.product.unit),
              listPrice: money(
                preview?.lines.elementAtOrNull(i)?.listUnitPrice,
              ),
              discount: _numField(l.discount, '%'),
              netPrice: money(preview?.lines.elementAtOrNull(i)?.netUnitPrice),
              total: money(preview?.lines.elementAtOrNull(i)?.lineTotal),
              onRemove: () {
                setState(() => _lines.removeAt(i).dispose());
                _refreshPreview();
              },
            ),
        ],
      ),
      const SizedBox(height: 8),
      Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: 420,
          child: SearchPicker<Product>(
            label: 'Add product',
            clearOnSelect: true,
            display: (p) => '${p.code} · ${p.name}',
            search: (q) async => (await _api.products.listProducts(
              q: q,
              active: true,
              limit: 20,
            )).items,
            onSelected: (p) {
              setState(() => _lines.add(_Line(p)));
              _refreshPreview();
            },
          ),
        ),
      ),
      if (_previewError != null)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            _previewError!,
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ),
      const SizedBox(height: 16),
      if (preview != null)
        _totals(
          theme,
          preview.subtotal,
          preview.vatGroups,
          preview.total,
          'EUR',
        ),
      const SizedBox(height: 16),
      TextField(
        controller: _notes,
        maxLines: 3,
        decoration: const InputDecoration(labelText: 'Notes'),
      ),
    ];
  }

  Widget _numField(TextEditingController c, String suffix) => SizedBox(
    width: 96,
    child: TextField(
      controller: c,
      textAlign: TextAlign.right,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(suffixText: suffix),
      onChanged: (_) => _onEdited(),
    ),
  );

  List<Widget> _readOnly(Quotation q, ThemeData theme) => [
    Text(q.customerName, style: theme.textTheme.titleMedium),
    Text(
      '${q.customerStreet}, ${q.customerPostalCode} ${q.customerCity} ${q.customerCountryCode}',
    ),
    Text(
      'Zone ${q.priceZoneCode} · discount ${number(q.customerDiscountPercent)} % · '
      '${date(q.quoteDate)} – valid until ${date(q.validUntil)}',
    ),
    const SizedBox(height: 16),
    _linesTable(
      theme,
      rows: [
        for (final l in q.lines)
          _TableRow(
            code: l.productCode,
            description: l.description,
            quantity: Text('${number(l.quantity)} ${l.unit}'),
            listPrice: money(l.listUnitPrice, currency: q.currency),
            discount: Text('${number(l.lineDiscountPercent)} %'),
            netPrice: money(l.netUnitPrice, currency: q.currency),
            total: money(l.lineTotal, currency: q.currency),
          ),
      ],
    ),
    const SizedBox(height: 16),
    _totals(theme, q.subtotal, q.vatGroups, q.total, q.currency),
    if (q.notes.isNotEmpty) ...[
      const SizedBox(height: 16),
      Text('Notes', style: theme.textTheme.labelLarge),
      Text(q.notes),
    ],
  ];

  Widget _linesTable(ThemeData theme, {required List<_TableRow> rows}) {
    const widths = [100.0, 260.0, 120.0, 110.0, 110.0, 110.0, 120.0, 48.0];
    Widget cell(int i, Widget child, {bool right = false}) => SizedBox(
      width: widths[i],
      child: Align(
        alignment: right ? Alignment.centerRight : Alignment.centerLeft,
        child: child,
      ),
    );
    Text h(String s) => Text(s, style: theme.textTheme.labelLarge);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              cell(0, h('Code')),
              cell(1, h('Description')),
              cell(2, h('Quantity'), right: true),
              cell(3, h('List price'), right: true),
              cell(4, h('Line disc.'), right: true),
              cell(5, h('Net price'), right: true),
              cell(6, h('Total'), right: true),
            ],
          ),
          const Divider(),
          for (final r in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  cell(0, Text(r.code)),
                  cell(1, Text(r.description, overflow: TextOverflow.ellipsis)),
                  cell(2, r.quantity, right: true),
                  cell(3, Text(r.listPrice), right: true),
                  cell(4, r.discount, right: true),
                  cell(5, Text(r.netPrice), right: true),
                  cell(6, Text(r.total), right: true),
                  if (r.onRemove != null)
                    cell(
                      7,
                      IconButton(
                        onPressed: r.onRemove,
                        icon: const Icon(Icons.close),
                      ),
                    ),
                ],
              ),
            ),
          if (rows.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('No lines yet.'),
            ),
        ],
      ),
    );
  }

  Widget _totals(
    ThemeData theme,
    String subtotal,
    List<VatGroup> vat,
    String total,
    String currency,
  ) => Align(
    alignment: Alignment.centerRight,
    child: SizedBox(
      width: 340,
      child: Column(
        children: [
          _totalRow('Total excl. VAT', money(subtotal, currency: currency)),
          for (final g in vat)
            _totalRow(
              'VAT ${number(g.vatRate)} % on ${money(g.baseValue, currency: currency)}',
              money(g.vat, currency: currency),
            ),
          const Divider(),
          _totalRow(
            'Total incl. VAT',
            money(total, currency: currency),
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
    ),
  );

  Widget _totalRow(String label, String value, {TextStyle? style}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(value, style: style),
      ],
    ),
  );
}

class _TableRow {
  _TableRow({
    required this.code,
    required this.description,
    required this.quantity,
    required this.listPrice,
    required this.discount,
    required this.netPrice,
    required this.total,
    this.onRemove,
  });

  final String code;
  final String description;
  final Widget quantity;
  final String listPrice;
  final Widget discount;
  final String netPrice;
  final String total;
  final VoidCallback? onRemove;
}
