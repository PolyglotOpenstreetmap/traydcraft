import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/api.dart';
import '../../shared/entity_list.dart';
import '../../shared/format.dart';

class ProductsPage extends ConsumerWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(apiProvider);
    return EntityList<Product>(
      title: 'Products',
      load: (q, offset, limit) async {
        final page = await api.products.listProducts(
          q: q,
          offset: offset,
          limit: limit,
        );
        return (page.items, page.total);
      },
      columns: [
        EntityColumn('Code', (p) => p.code),
        EntityColumn('Name', (p) => p.name, flex: 3),
        EntityColumn('Type', (p) => p.productType),
        EntityColumn('Unit', (p) => p.unit),
        EntityColumn('VAT', (p) => '${number(p.vatRate)} %', numeric: true),
      ],
      onOpen: (p) => showDialog<bool>(
        context: context,
        builder: (_) => ProductPrices(product: p),
      ),
    );
  }
}

final _pricesProvider = FutureProvider.autoDispose
    .family<List<ZonePriceEntry>, String>(
      (ref, productId) =>
          ref.watch(apiProvider).products.listProductPrices(id: productId),
    );

/// Price history per zone. Prices are never edited: a new price starts on a date.
class ProductPrices extends ConsumerWidget {
  const ProductPrices({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prices = ref.watch(_pricesProvider(product.id));
    final canWrite =
        ref.watch(meProvider).value?.permissions.contains('prices.write') ??
        false;
    return AlertDialog(
      title: Text('${product.code} · ${product.name}'),
      content: SizedBox(
        width: 520,
        child: prices.when(
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text(errorMessage(e)),
          data: (list) => list.isEmpty
              ? const Text('No prices yet.')
              : SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Zone')),
                      DataColumn(label: Text('Valid from')),
                      DataColumn(label: Text('Unit price'), numeric: true),
                    ],
                    rows: [
                      for (final p in list)
                        DataRow(
                          cells: [
                            DataCell(Text(p.zoneCode)),
                            DataCell(Text(date(p.validFrom))),
                            DataCell(Text(money(p.unitPrice))),
                          ],
                        ),
                    ],
                  ),
                ),
        ),
      ),
      actions: [
        if (canWrite)
          TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('New price'),
            onPressed: () async {
              final added = await showDialog<bool>(
                context: context,
                builder: (_) => _NewPrice(product: product),
              );
              if (added == true) ref.invalidate(_pricesProvider(product.id));
            },
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _NewPrice extends ConsumerStatefulWidget {
  const _NewPrice({required this.product});
  final Product product;

  @override
  ConsumerState<_NewPrice> createState() => _NewPriceState();
}

class _NewPriceState extends ConsumerState<_NewPrice> {
  final _price = TextEditingController();
  String? _zoneId;
  DateTime _from = DateTime.now();
  String? _error;

  Future<void> _save() async {
    final price = parseDecimalInput(_price.text);
    if (_zoneId == null || price == null) {
      setState(() => _error = 'Choose a zone and enter a price.');
      return;
    }
    try {
      await ref
          .read(apiProvider)
          .products
          .addProductPrice(
            id: widget.product.id,
            body: ZonePriceInput(
              zoneId: _zoneId!,
              unitPrice: price,
              validFrom: _from,
            ),
          );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => _error = errorMessage(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final zones = ref.watch(priceZonesProvider).value ?? const [];
    return AlertDialog(
      title: const Text('New price'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _zoneId,
            decoration: const InputDecoration(labelText: 'Zone'),
            items: [
              for (final z in zones)
                DropdownMenuItem(
                  value: z.id,
                  child: Text('${z.code} – ${z.name}'),
                ),
            ],
            onChanged: (v) => setState(() => _zoneId = v),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _price,
            decoration: const InputDecoration(
              labelText: 'Unit price (excl. VAT)',
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Valid from ${date(_from)}'),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final d = await showDatePicker(
                context: context,
                initialDate: _from,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (d != null) setState(() => _from = d);
            },
          ),
          if (_error != null)
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
        ],
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
