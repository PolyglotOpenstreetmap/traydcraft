import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/api.dart';
import '../../shared/entity_list.dart';
import '../../shared/format.dart';
import 'bulk_price_dialog.dart';
import 'families_dialog.dart';
import 'product_form.dart';
import '../../l10n/l10n.dart';

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
      title: context.l10n.products,
      load: (q, offset, limit) async {
        final page = await api.products.listProducts(
          q: q,
          offset: offset,
          limit: limit,
        );
        return (page.items, page.total);
      },
      columns: [
        EntityColumn(context.l10n.code, (p) => p.code),
        EntityColumn(context.l10n.name, (p) => p.name, flex: 3),
        EntityColumn(context.l10n.family, (p) => p.familyCode ?? ''),
        EntityColumn(
          context.l10n.type,
          (p) => context.l10n.productType(p.productType),
        ),
        EntityColumn(
          context.l10n.pricing,
          (p) => p.pricingType == 'list'
              ? ''
              : context.l10n.pricingType(p.pricingType),
        ),
        EntityColumn(
          context.l10n.tracking,
          (p) => context.l10n.trackingLabel(p.tracking),
        ),
        EntityColumn(context.l10n.unit, (p) => p.unit),
        EntityColumn(
          context.l10n.vat,
          (p) => '${number(p.vatRate)} %',
          numeric: true,
        ),
      ],
      actions: [
        OutlinedButton.icon(
          icon: const Icon(Icons.category_outlined),
          label: Text(context.l10n.families),
          onPressed: () => showDialog<void>(
            context: context,
            builder: (_) => const FamiliesDialog(),
          ),
        ),
        if (canChangePrices)
          OutlinedButton.icon(
            icon: const Icon(Icons.trending_up),
            label: Text(context.l10n.bulkPriceChange),
            onPressed: () => showDialog<bool>(
              context: context,
              builder: (_) => const BulkPriceDialog(),
            ),
          ),
      ],
      createLabel: context.l10n.newProduct,
      onCreate: canWrite
          ? () async => await showProductForm(context) != null
          : null,
      onOpen: (p) async =>
          await context.push<bool>('/products/${p.id}') ?? true,
    );
  }
}
