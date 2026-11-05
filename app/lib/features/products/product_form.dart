import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/api.dart';
import '../../shared/format.dart';

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
  late bool _active = p?.active ?? true;
  String? _error;

  Future<void> _save() async {
    final vat = parseDecimalInput(_vat.text);
    if (_code.text.trim().isEmpty || _name.text.trim().isEmpty || vat == null) {
      setState(() => _error = 'Code, name and VAT rate are required.');
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
      title: Text(p == null ? 'New product' : p!.code),
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
                    decoration: const InputDecoration(labelText: 'Code'),
                  ),
                ),
                gap,
                Expanded(
                  child: TextField(
                    controller: _name,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                ),
              ],
            ),
            gap,
            TextField(
              controller: _description,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            gap,
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _type,
                    decoration: const InputDecoration(labelText: 'Type'),
                    items: [
                      for (final t in productTypes)
                        DropdownMenuItem(value: t, child: Text(t)),
                    ],
                    onChanged: (v) => setState(() => _type = v!),
                  ),
                ),
                gap,
                SizedBox(
                  width: 90,
                  child: TextField(
                    controller: _unit,
                    decoration: const InputDecoration(labelText: 'Unit'),
                  ),
                ),
                gap,
                SizedBox(
                  width: 90,
                  child: TextField(
                    controller: _vat,
                    decoration: const InputDecoration(labelText: 'VAT %'),
                  ),
                ),
              ],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Serial numbers'),
              subtitle: const Text(
                'Every unit gets its own serial number and history',
              ),
              value: _serial,
              onChanged: _type == 'service'
                  ? null
                  : (v) => setState(() => _serial = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Active'),
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
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
