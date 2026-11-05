import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/api.dart';
import '../../l10n/l10n.dart';
import '../../shared/entity_list.dart';
import '../../shared/format.dart';

class OrdersPage extends ConsumerWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final api = ref.watch(apiProvider);
    return EntityList<OrderSummary>(
      title: l.orders,
      load: (q, offset, limit) async {
        final page = await api.sales.listOrders(
          q: q,
          offset: offset,
          limit: limit,
        );
        return (page.items, page.total);
      },
      columns: [
        EntityColumn(l.number, (o) => o.number),
        EntityColumn(l.customer, (o) => o.customerName, flex: 3),
        EntityColumn(l.customerReference, (o) => o.customerReference, flex: 2),
        EntityColumn(
          l.quotation,
          (o) => '${o.quotationNumber} rev. ${o.quotationRevision}',
          flex: 2,
        ),
        EntityColumn(l.date, (o) => date(o.orderDate)),
        EntityColumn(l.salesperson, (o) => o.salespersonName, flex: 2),
        EntityColumn(
          l.totalExclVat,
          (o) => money(o.subtotal, currency: o.currency),
          numeric: true,
          flex: 2,
        ),
      ],
      onOpen: (o) async => await context.push<bool>('/orders/${o.id}') ?? false,
    );
  }
}
