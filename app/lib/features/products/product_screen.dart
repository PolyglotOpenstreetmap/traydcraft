import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/api.dart';
import '../../shared/actions.dart';
import '../../shared/format.dart';
import 'bom_tab.dart';
import 'prices_tab.dart';
import 'product_form.dart';
import 'serials_tab.dart';

final productProvider = FutureProvider.autoDispose.family<Product, String>(
  (ref, id) => ref.watch(apiProvider).products.getProduct(id: id),
);

/// Product detail: prices, bill of materials and serial numbers.
class ProductScreen extends ConsumerWidget {
  const ProductScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productProvider(id));
    final canWrite =
        ref.watch(meProvider).value?.permissions.contains('products.write') ??
        false;
    return Scaffold(
      body: product.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(errorMessage(e))),
        data: (p) {
          final hasBom =
              p.productType == 'manufactured' ||
              p.productType == 'configurable';
          final serial = p.tracking == 'serial';
          final tabs = [
            const Tab(text: 'Prices'),
            if (hasBom) const Tab(text: 'Bill of materials'),
            if (serial) const Tab(text: 'Serial numbers'),
          ];
          return DefaultTabController(
            length: tabs.length,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Wrap(
                    spacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => context.canPop()
                            ? context.pop(true)
                            : context.go('/products'),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      Text(
                        '${p.code} · ${p.name}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      if (canWrite)
                        OutlinedButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                          onPressed: () async {
                            if (await showProductForm(context, product: p) !=
                                null) {
                              ref.invalidate(productProvider(id));
                            }
                          },
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Wrap(
                    children: [
                      InfoItem('Type', p.productType),
                      InfoItem('Unit', p.unit),
                      InfoItem('VAT', '${number(p.vatRate)} %'),
                      InfoItem('Tracking', serial ? 'serial numbers' : 'none'),
                      InfoItem('Family', p.familyCode ?? ''),
                      InfoItem('Pricing', p.pricingType),
                      InfoItem('Status', p.active ? 'active' : 'inactive'),
                      if (p.description.isNotEmpty)
                        InfoItem('Description', p.description),
                    ],
                  ),
                ),
                TabBar(isScrollable: true, tabs: tabs),
                Expanded(
                  child: TabBarView(
                    children: [
                      PricesTab(product: p),
                      if (hasBom) BomTab(product: p),
                      if (serial) SerialsTab(product: p),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
