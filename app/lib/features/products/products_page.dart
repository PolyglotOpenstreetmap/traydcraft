import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/api.dart';
import '../../shared/entity_list.dart';
import '../../shared/format.dart';
import 'bulk_price_dialog.dart';
import 'families_dialog.dart';
import 'product_form.dart';

class ProductsPage extends ConsumerWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(apiProvider);
    final canChangePrices =
        ref.watch(meProvider).value?.permissions.contains('prices.write') ??
        false;
    final canWrite =
        ref.watch(meProvider).value?.permissions.contains('products.write') ??
        false;
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
        EntityColumn('Family', (p) => p.familyCode ?? ''),
        EntityColumn('Type', (p) => p.productType),
        EntityColumn(
          'Pricing',
          (p) => p.pricingType == 'list' ? '' : p.pricingType,
        ),
        EntityColumn('Tracking', (p) => p.tracking == 'serial' ? 'serial' : ''),
        EntityColumn('Unit', (p) => p.unit),
        EntityColumn('VAT', (p) => '${number(p.vatRate)} %', numeric: true),
      ],
      actions: [
        OutlinedButton.icon(
          icon: const Icon(Icons.category_outlined),
          label: const Text('Families'),
          onPressed: () => showDialog<void>(
            context: context,
            builder: (_) => const FamiliesDialog(),
          ),
        ),
        if (canChangePrices)
          OutlinedButton.icon(
            icon: const Icon(Icons.trending_up),
            label: const Text('Bulk price change'),
            onPressed: () => showDialog<bool>(
              context: context,
              builder: (_) => const BulkPriceDialog(),
            ),
          ),
      ],
      createLabel: 'New product',
      onCreate: canWrite
          ? () async => await showProductForm(context) != null
          : null,
      onOpen: (p) async =>
          await context.push<bool>('/products/${p.id}') ?? true,
    );
  }
}
