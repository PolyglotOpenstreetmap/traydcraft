import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';

import '../../app/api.dart';
import '../../shared/format.dart';
import '../../shared/search_picker.dart';
import '../../l10n/l10n.dart';

/// An editable line of a draft. Prices are never computed here: they come from
/// the server's pricing preview, matched by position.
class _Line {
  _Line(
    this.product, {
    String quantity = '1',
    String discount = '0',
    String price = '',
    this.description,
  }) : quantity = TextEditingController(text: quantity),
       discount = TextEditingController(text: discount),
       price = TextEditingController(text: price);

  final Product product;
  final TextEditingController quantity;
  final TextEditingController discount;

  /// Confirmed price of an indicative product; empty while unconfirmed.
  final TextEditingController price;
  final String? description;

  bool get isNet => product.pricingType == 'net';
  bool get isIndicative => product.pricingType == 'indicative';

  void dispose() {
    quantity.dispose();
    discount.dispose();
    price.dispose();
  }
}

/// Create, edit (drafts), view and process a quotation.
class QuotationScreen extends ConsumerStatefulWidget {
  const QuotationScreen({
    super.key,
    this.id,
    this.customerId,
    this.opportunityId,
  });

  final String? id;

  /// Pre-selects the customer and opportunity of a new quotation.
  final String? customerId;
  final String? opportunityId;

  @override
  ConsumerState<QuotationScreen> createState() => _QuotationPageState();
}

class _QuotationPageState extends ConsumerState<QuotationScreen> {
  late String? _id = widget.id;
  Quotation? _q;
  Customer? _customer;
  late String? _opportunityId = widget.opportunityId;
  List<Opportunity> _opportunities = [];

  /// Price list date; null = the quote date (today for a new quotation).
  DateTime? _priceDate;
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
    if (_id != null) {
      _load();
    } else if (widget.customerId != null) {
      _api.crm
          .getCustomer(id: widget.customerId!)
          .then(
            _selectCustomer,
            onError: (Object e) {
              if (mounted) setState(() => _error = errorMessage(e));
            },
          );
    }
  }

  /// Selects a customer and loads their open opportunities.
  Future<void> _selectCustomer(Customer c) async {
    setState(() => _customer = c);
    _refreshPreview();
    // Linking an opportunity is optional: without access to opportunities, quoting still works.
    final opportunities = await _api.crm
        .listOpportunities(customerId: c.id, open: true, limit: 100)
        .then((p) => p.items, onError: (Object _) => <Opportunity>[]);
    if (!mounted) return;
    setState(() {
      _opportunities = opportunities;
      if (!_opportunities.any((o) => o.id == _opportunityId)) {
        _opportunityId = null;
      }
    });
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
        _opportunityId = q.opportunityId;
        await _selectCustomer(customer);
        setState(() {
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
                      price: l.pricingType == 'indicative' && l.priceConfirmed
                          ? number(l.listUnitPrice)
                          : '',
                      description: l.description,
                    ),
                  ),
            );
          _notes.text = q.notes;
          _priceDate = q.priceDate;
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
      final price = l.isIndicative && l.price.text.trim().isNotEmpty
          ? parseDecimalInput(l.price.text)
          : null;
      if (qty == null ||
          disc == null ||
          (l.isIndicative && l.price.text.trim().isNotEmpty && price == null)) {
        _previewError = context.l10n.enterValidNumbersLine(i + 1);
        return null;
      }
      inputs.add(
        QuotationLineInput(
          productId: l.product.id,
          quantity: qty,
          lineDiscountPercent: disc,
          description: l.description,
          unitPrice: price,
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
        body: PricingPreviewInput(
          customerId: customer.id,
          quoteDate: _q?.quoteDate,
          priceDate: _priceDate,
          lines: inputs,
        ),
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
      throw context.l10n.chooseCustomerAndLine;
    }
    final body = QuotationInput(
      customerId: _customer!.id,
      opportunityId: _opportunityId,
      priceDate: _priceDate,
      notes: _notes.text,
      lines: inputs,
    );
    final q = _id == null
        ? await _api.sales.createQuotation(body: body)
        : await _api.sales.updateQuotation(id: _id!, body: body);
    _apply(q);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.savedNumber(q.number))),
      );
    }
  });

  Future<void> _transition(Future<Quotation> Function(String id) call) =>
      _run(() async => _apply(await call(_id!)));

  /// Shows what today's prices would change, then lets the user keep or update the prices.
  Future<void> _revise() async {
    final pricing = await showDialog<RevisionPricing>(
      context: context,
      builder: (_) => RevisionDialog(quotation: _q!),
    );
    if (pricing == null) return;
    await _run(() async {
      final rev = await _api.sales.reviseQuotation(
        id: _id!,
        body: ReviseInput(pricing: pricing),
      );
      if (mounted) context.pushReplacement('/quotations/${rev.id}');
    });
  }

  Future<void> _pickPriceDate() async {
    final d = await showDatePicker(
      context: context,
      helpText: context.l10n.priceListValidOn,
      initialDate: _priceDate ?? _q?.quoteDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d == null) return;
    setState(() => _priceDate = d);
    _refreshPreview();
  }

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
                          ? context.l10n.newQuotation
                          : '${q.number}  rev. ${q.revision}',
                      style: theme.textTheme.headlineSmall,
                    ),
                    if (q != null)
                      Chip(
                        label: Text(
                          context.l10n.quotationStatus(q.status.json ?? ''),
                        ),
                      ),
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
          label: Text(context.l10n.saveDraft),
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
          label: Text(context.l10n.markAsSent),
        ),
      if (s == QuotationStatus.sent) ...[
        OutlinedButton(
          onPressed: _busy
              ? null
              : () => _transition((id) => _api.sales.acceptQuotation(id: id)),
          child: Text(context.l10n.accepted),
        ),
        OutlinedButton(
          onPressed: _busy
              ? null
              : () => _transition((id) => _api.sales.rejectQuotation(id: id)),
          child: Text(context.l10n.rejected),
        ),
      ],
      if (s == QuotationStatus.sent || s == QuotationStatus.rejected)
        OutlinedButton.icon(
          onPressed: _busy ? null : _revise,
          icon: const Icon(Icons.edit_note),
          label: Text(context.l10n.newRevision),
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
              label: context.l10n.customer,
              initial: _customer,
              display: (c) => '${c.code} · ${c.name}',
              search: (q) async =>
                  (await _api.crm.listCustomers(q: q, limit: 20)).items,
              onSelected: _selectCustomer,
            ),
          ),
          const SizedBox(width: 16),
          if (_customer != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '${context.l10n.zoneAndRebate(_customer!.priceZoneCode ?? '—', number(_customer!.discountPercent ?? '0'))}\n'
                '${_customer!.street}, ${_customer!.postalCode} ${_customer!.city}',
              ),
            ),
        ],
      ),
      if (_customer != null) ...[
        const SizedBox(height: 12),
        SizedBox(
          width: 520,
          child: DropdownButtonFormField<String?>(
            key: ValueKey('opp-${_customer!.id}-${_opportunities.length}'),
            initialValue: _opportunityId,
            decoration: InputDecoration(
              labelText: context.l10n.opportunityOptional,
            ),
            items: [
              DropdownMenuItem<String?>(
                value: null,
                child: Text(context.l10n.none),
              ),
              for (final o in _opportunities)
                DropdownMenuItem<String?>(
                  value: o.id,
                  child: Text(
                    '${o.number} · ${o.title} (${context.l10n.opportunityStage(o.stage.json ?? '')})',
                  ),
                ),
            ],
            onChanged: (v) => setState(() => _opportunityId = v),
          ),
        ),
      ],
      const SizedBox(height: 12),
      Wrap(
        spacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            context.l10n.priceListOf(
              date(
                preview?.priceDate ??
                    _priceDate ??
                    _q?.quoteDate ??
                    DateTime.now(),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: _pickPriceDate,
            icon: const Icon(Icons.history),
            label: Text(context.l10n.useAnotherPriceListDate),
          ),
        ],
      ),
      if ((preview?.unconfirmedLines ?? 0) > 0)
        MaterialBanner(
          leading: const Icon(Icons.info_outline),
          content: Text(
            context.l10n.indicativeToConfirm(preview!.unconfirmedLines),
          ),
          actions: const [SizedBox.shrink()],
        ),
      const SizedBox(height: 8),
      _linesTable(
        theme,
        rows: [
          for (final (i, l) in _lines.indexed)
            _TableRow(
              code: l.product.code,
              description: l.description ?? l.product.name,
              quantity: _numField(l.quantity, l.product.unit),
              listPrice: l.isIndicative
                  ? _numField(
                      l.price,
                      '€',
                      hint: number(
                        preview?.lines.elementAtOrNull(i)?.listUnitPrice,
                      ),
                      label: l.price.text.trim().isEmpty
                          ? context.l10n.confirm
                          : null,
                    )
                  : Text(
                      money(preview?.lines.elementAtOrNull(i)?.listUnitPrice),
                    ),
              rebate: _rebateText(preview?.lines.elementAtOrNull(i)),
              discount: l.isNet
                  ? Text(context.l10n.pricingNet)
                  : _numField(l.discount, '%'),
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
            label: context.l10n.addProduct,
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
        decoration: InputDecoration(labelText: context.l10n.notes),
      ),
    ];
  }

  Widget _numField(
    TextEditingController c,
    String suffix, {
    String? hint,
    String? label,
  }) => SizedBox(
    width: 104,
    child: TextField(
      controller: c,
      textAlign: TextAlign.right,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        suffixText: suffix,
        hintText: hint,
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      onChanged: (_) {
        _onEdited();
        if (label != null) setState(() {});
      },
    ),
  );

  /// "12 % family", "5 % general", "net".
  String _rebateText(QuotationLine? l) {
    if (l == null) return '';
    if (l.rebateSource == 'net') return 'net';
    return '${number(l.rebatePercent)} % ${context.l10n.rebateSource(l.rebateSource)}';
  }

  List<Widget> _readOnly(Quotation q, ThemeData theme) => [
    Text(q.customerName, style: theme.textTheme.titleMedium),
    Text(
      '${q.customerStreet}, ${q.customerPostalCode} ${q.customerCity} ${q.customerCountryCode}',
    ),
    Text(
      '${context.l10n.zoneAndRebate(q.priceZoneCode, number(q.customerDiscountPercent))} · '
      '${date(q.quoteDate)} – ${context.l10n.validUntil(date(q.validUntil))}',
    ),
    if (q.priceDate != q.quoteDate)
      Text(
        context.l10n.pricedOnPriceListOf(date(q.priceDate)),
        style: TextStyle(color: theme.colorScheme.tertiary),
      ),
    if (q.opportunityId != null)
      Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          icon: const Icon(Icons.trending_up),
          label: Text(context.l10n.openOpportunity),
          onPressed: () => context.push('/opportunities/${q.opportunityId}'),
        ),
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
            listPrice: Text(money(l.listUnitPrice, currency: q.currency)),
            rebate: _rebateText(l),
            discount: Text(
              l.pricingType == 'net'
                  ? context.l10n.pricingNet
                  : '${number(l.lineDiscountPercent)} %',
            ),
            netPrice: money(l.netUnitPrice, currency: q.currency),
            total: money(l.lineTotal, currency: q.currency),
          ),
      ],
    ),
    const SizedBox(height: 16),
    _totals(theme, q.subtotal, q.vatGroups, q.total, q.currency),
    if (q.notes.isNotEmpty) ...[
      const SizedBox(height: 16),
      Text(context.l10n.notes, style: theme.textTheme.labelLarge),
      Text(q.notes),
    ],
  ];

  Widget _linesTable(ThemeData theme, {required List<_TableRow> rows}) {
    const widths = [
      100.0,
      240.0,
      120.0,
      120.0,
      120.0,
      110.0,
      110.0,
      120.0,
      48.0,
    ];
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
              cell(0, h(context.l10n.code)),
              cell(1, h(context.l10n.description)),
              cell(2, h(context.l10n.quantity), right: true),
              cell(3, h(context.l10n.listPrice), right: true),
              cell(4, h(context.l10n.rebate), right: true),
              cell(5, h(context.l10n.lineDiscount), right: true),
              cell(6, h(context.l10n.netPrice), right: true),
              cell(7, h(context.l10n.total), right: true),
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
                  cell(3, r.listPrice, right: true),
                  cell(4, Text(r.rebate), right: true),
                  cell(5, r.discount, right: true),
                  cell(6, Text(r.netPrice), right: true),
                  cell(7, Text(r.total), right: true),
                  if (r.onRemove != null)
                    cell(
                      8,
                      IconButton(
                        onPressed: r.onRemove,
                        icon: const Icon(Icons.close),
                      ),
                    ),
                ],
              ),
            ),
          if (rows.isEmpty)
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(context.l10n.noLines),
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
          _totalRow(
            context.l10n.totalExclVat,
            money(subtotal, currency: currency),
          ),
          for (final g in vat)
            _totalRow(
              context.l10n.vatOn(
                number(g.vatRate),
                money(g.baseValue, currency: currency),
              ),
              money(g.vat, currency: currency),
            ),
          const Divider(),
          _totalRow(
            context.l10n.totalInclVat,
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
    required this.rebate,
    required this.discount,
    required this.netPrice,
    required this.total,
    this.onRemove,
  });

  final String code;
  final String description;
  final Widget quantity;
  final Widget listPrice;
  final String rebate;
  final Widget discount;
  final String netPrice;
  final String total;
  final VoidCallback? onRemove;
}

/// Compares a quotation with today's prices and asks whether to keep or update them.
class RevisionDialog extends ConsumerWidget {
  const RevisionDialog({super.key, required this.quotation});
  final Quotation quotation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(context.l10n.newRevisionOf(quotation.number)),
      content: SizedBox(
        width: 760,
        child: FutureBuilder<RepricingComparison>(
          future: ref.read(apiProvider).sales.repricing(id: quotation.id),
          builder: (context, snap) {
            if (snap.hasError) {
              return Text(
                '${context.l10n.repricingFailed(errorMessage(snap.error!))}\n${context.l10n.canStillKeep}',
              );
            }
            final c = snap.data;
            if (c == null) {
              return const SizedBox(
                height: 80,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            Text h(String s) => Text(s, style: theme.textTheme.labelLarge);
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.revisionPriceLists(
                      date(c.oldPriceDate),
                      date(c.newPriceDate),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Table(
                    columnWidths: const {1: FlexColumnWidth()},
                    defaultColumnWidth: const IntrinsicColumnWidth(),
                    children: [
                      TableRow(
                        children: [
                          for (final t in [
                            context.l10n.code,
                            context.l10n.description,
                            context.l10n.agreed,
                            context.l10n.current,
                            context.l10n.difference,
                          ])
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: h(t),
                            ),
                        ],
                      ),
                      for (final l in c.lines)
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Text(l.productCode),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Text(
                                l.needsConfirmation
                                    ? context.l10n.indicativeLine(l.description)
                                    : l.description,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Text(
                                money(l.oldLineTotal),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Text(
                                money(l.newLineTotal),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Text(
                                money(l.difference),
                                textAlign: TextAlign.right,
                                style: _diffStyle(theme, l.difference),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const Divider(),
                  Text(
                    context.l10n.totalChange(
                      money(c.oldSubtotal),
                      money(c.newSubtotal),
                      money(c.difference),
                    ),
                    style: theme.textTheme.titleSmall?.merge(
                      _diffStyle(theme, c.difference),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        OutlinedButton(
          onPressed: () => Navigator.pop(context, RevisionPricing.keep),
          child: Text(context.l10n.keepAgreedPrices),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, RevisionPricing.current),
          child: Text(context.l10n.updateToCurrentPrices),
        ),
      ],
    );
  }

  static TextStyle? _diffStyle(ThemeData theme, String value) {
    final v = double.tryParse(value) ?? 0;
    if (v == 0) return null;
    return TextStyle(
      color: v > 0 ? theme.colorScheme.error : Colors.green.shade700,
    );
  }
}
