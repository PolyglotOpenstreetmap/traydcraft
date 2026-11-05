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
  late bool _serial = p?.tracking == 'serial';
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
    final body = ProductInput(
      code: _code.text.trim(),
      name: _name.text.trim(),
      description: _description.text,
      unit: _unit.text.trim(),
      productType: _type,
      vatRate: vat,
      tracking: _serial ? 'serial' : 'none',
      familyId: _familyId,
      pricingType: _pricing,
      active: _active,
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
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.l10n.serialNumbers),
              subtitle: Text(context.l10n.serialNumbersHelp),
              value: _serial,
              onChanged: _type == 'service'
                  ? null
                  : (v) => setState(() => _serial = v),
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
