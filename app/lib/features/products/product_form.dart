import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/api.dart';
import '../../shared/format.dart';
import 'families_dialog.dart';
import '../../l10n/l10n.dart';

const productTypes = ['purchased', 'manufactured', 'configurable', 'service'];

/// Create or edit a product. Returns the saved product, or null when cancelled.
Future<Product?> showProductForm(BuildContext context, {Product? product}) =>
    showDialog<Product>(
      context: context,
      builder: (_) => ProductForm(product: product),
    );

class ProductForm extends ConsumerStatefulWidget {
  const ProductForm({super.key, this.product});
  final Product? product;

  @override
  ConsumerState<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends ConsumerState<ProductForm> {
  late final p = widget.product;
  late final _code = TextEditingController(text: p?.code);
  late final _name = TextEditingController(text: p?.name);
  late final _description = TextEditingController(text: p?.description);
  late final _unit = TextEditingController(text: p?.unit ?? 'pcs');
  late final _vat = TextEditingController(text: number(p?.vatRate ?? '21'));
  late String _type = p?.productType ?? 'purchased';
  late String _tracking = p?.tracking ?? 'none';
  late final _cost = TextEditingController(text: number(p?.standardCost));
  late final _reorderMin = TextEditingController(text: number(p?.reorderMin));
  late final _reorderMax = TextEditingController(text: number(p?.reorderMax));
  late final _leadTime = TextEditingController(
    text: p?.leadTimeDays?.toString() ?? '',
  );
  late final _barcode = TextEditingController(text: p?.barcode);
  late String? _familyId = p?.familyId;
  late String _pricing = p?.pricingType ?? 'list';
  late bool _active = p?.active ?? true;
  String? _error;

  Future<void> _save() async {
    final vat = parseDecimalInput(_vat.text);
    if (_code.text.trim().isEmpty || _name.text.trim().isEmpty || vat == null) {
      setState(() => _error = context.l10n.codeNameVatRequired);
      return;
    }
    final cost = _cost.text.trim().isEmpty
        ? null
        : parseDecimalInput(_cost.text);
    final min = _reorderMin.text.trim().isEmpty
        ? null
        : parseDecimalInput(_reorderMin.text);
    final max = _reorderMax.text.trim().isEmpty
        ? null
        : parseDecimalInput(_reorderMax.text);
    final lead = _leadTime.text.trim().isEmpty
        ? null
        : int.tryParse(_leadTime.text.trim());
    if ((_cost.text.trim().isNotEmpty && cost == null) ||
        (_reorderMin.text.trim().isNotEmpty && min == null) ||
        (_reorderMax.text.trim().isNotEmpty && max == null) ||
        (_leadTime.text.trim().isNotEmpty && lead == null)) {
      setState(() => _error = context.l10n.stockInvalidNumbers);
      return;
    }
    final body = ProductInput(
      code: _code.text.trim(),
      name: _name.text.trim(),
      description: _description.text,
      unit: _unit.text.trim(),
      productType: _type,
      vatRate: vat,
      tracking: _type == 'service' ? 'none' : _tracking,
      familyId: _familyId,
      pricingType: _pricing,
      active: _active,
      standardCost: cost,
      reorderMin: min,
      reorderMax: max,
      leadTimeDays: lead,
      barcode: _barcode.text.trim().isEmpty ? null : _barcode.text.trim(),
    );
    try {
      final api = ref.read(apiProvider).products;
      final saved = p == null
          ? await api.createProduct(body: body)
          : await api.updateProduct(id: p!.id, body: body);
      if (mounted) Navigator.pop(context, saved);
    } catch (e) {
      setState(() => _error = errorMessage(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 12, width: 12);
    return AlertDialog(
      title: Text(p == null ? context.l10n.newProduct : p!.code),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 160,
                  child: TextField(
                    controller: _code,
                    decoration: InputDecoration(labelText: context.l10n.code),
                  ),
                ),
                gap,
                Expanded(
                  child: TextField(
                    controller: _name,
                    decoration: InputDecoration(labelText: context.l10n.name),
                  ),
                ),
              ],
            ),
            gap,
            TextField(
              controller: _description,
              decoration: InputDecoration(labelText: context.l10n.description),
            ),
            gap,
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _type,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: context.l10n.type),
                    items: [
                      for (final t in productTypes)
                        DropdownMenuItem(
                          value: t,
                          child: Text(context.l10n.productType(t)),
                        ),
                    ],
                    onChanged: (v) => setState(() => _type = v!),
                  ),
                ),
                gap,
                SizedBox(
                  width: 90,
                  child: TextField(
                    controller: _unit,
                    decoration: InputDecoration(labelText: context.l10n.unit),
                  ),
                ),
                gap,
                SizedBox(
                  width: 90,
                  child: TextField(
                    controller: _vat,
                    decoration: InputDecoration(
                      labelText: context.l10n.vatPercent,
                    ),
                  ),
                ),
              ],
            ),
            gap,
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    initialValue: _familyId,
                    decoration: InputDecoration(labelText: context.l10n.family),
                    items: [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text(context.l10n.none),
                      ),
                      for (final f
                          in ref.watch(familiesProvider).value ??
                              <ProductFamily>[])
                        DropdownMenuItem<String?>(
                          value: f.id,
                          child: Text('${f.code} · ${f.name}'),
                        ),
                    ],
                    onChanged: (v) => setState(() => _familyId = v),
                  ),
                ),
                gap,
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _pricing,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: context.l10n.pricing,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'list',
                        child: Text(context.l10n.pricingListHelp),
                      ),
                      DropdownMenuItem(
                        value: 'net',
                        child: Text(context.l10n.pricingNetHelp),
                      ),
                      DropdownMenuItem(
                        value: 'indicative',
                        child: Text(context.l10n.pricingIndicativeHelp),
                      ),
                    ],
                    onChanged: (v) => setState(() => _pricing = v!),
                  ),
                ),
              ],
            ),
            DropdownButtonFormField<String>(
              initialValue: _tracking,
              isExpanded: true,
              decoration: InputDecoration(labelText: context.l10n.tracking),
              items: [
                DropdownMenuItem(value: 'none', child: Text(context.l10n.none)),
                DropdownMenuItem(
                  value: 'serial',
                  child: Text(context.l10n.serialNumbers),
                ),
                DropdownMenuItem(
                  value: 'lot',
                  child: Text(context.l10n.stockLotTrackingHelp),
                ),
              ],
              onChanged: _type == 'service'
                  ? null
                  : (v) => setState(() => _tracking = v!),
            ),
            gap,
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _reorderMin,
                    decoration: InputDecoration(
                      labelText: context.l10n.stockReorderMin,
                    ),
                  ),
                ),
                gap,
                Expanded(
                  child: TextField(
                    controller: _reorderMax,
                    decoration: InputDecoration(
                      labelText: context.l10n.stockReorderMax,
                    ),
                  ),
                ),
                gap,
                Expanded(
                  child: TextField(
                    controller: _leadTime,
                    decoration: InputDecoration(
                      labelText: context.l10n.stockLeadTime,
                    ),
                  ),
                ),
              ],
            ),
            gap,
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _barcode,
                    decoration: InputDecoration(
                      labelText: context.l10n.stockBarcode,
                    ),
                  ),
                ),
                // Cost is only offered to people who may see it (the server also enforces it).
                if (ref
                        .watch(meProvider)
                        .value
                        ?.permissions
                        .contains('inventory.cost') ??
                    false) ...[
                  gap,
                  Expanded(
                    child: TextField(
                      controller: _cost,
                      decoration: InputDecoration(
                        labelText: context.l10n.stockStandardCost,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.l10n.active),
              value: _active,
              onChanged: (v) => setState(() => _active = v),
            ),
            if (_error != null)
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(onPressed: _save, child: Text(context.l10n.save)),
      ],
    );
  }
}
