import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/api.dart';
import '../../shared/entity_list.dart';
import 'customer_form.dart';
import '../../l10n/l10n.dart';

class CustomersPage extends ConsumerWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(apiProvider);
    final canWrite =
        ref.watch(meProvider).value?.permissions.contains('customers.write') ??
        false;
    return EntityList<Customer>(
      title: context.l10n.customers,
      load: (q, offset, limit) async {
        final page = await api.crm.listCustomers(
          q: q,
          offset: offset,
          limit: limit,
        );
        return (page.items, page.total);
      },
      columns: [
        EntityColumn(context.l10n.code, (c) => c.code),
        EntityColumn(context.l10n.name, (c) => c.name, flex: 3),
        EntityColumn(context.l10n.city, (c) => c.city, flex: 2),
        EntityColumn(context.l10n.vat, (c) => c.vatNumber ?? '', flex: 2),
        EntityColumn(context.l10n.zone, (c) => c.priceZoneCode ?? '—'),
      ],
      createLabel: context.l10n.newCustomer,
      onCreate: canWrite ? () => showCustomerForm(context) : null,
      onOpen: (c) =>
          showCustomerForm(context, customer: c, readOnly: !canWrite),
    );
  }
}
