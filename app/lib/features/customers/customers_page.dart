import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/api.dart';
import '../../shared/entity_list.dart';
import 'customer_form.dart';

class CustomersPage extends ConsumerWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(apiProvider);
    final canWrite =
        ref.watch(meProvider).value?.permissions.contains('customers.write') ??
        false;
    return EntityList<Customer>(
      title: 'Customers',
      load: (q, offset, limit) async {
        final page = await api.crm.listCustomers(
          q: q,
          offset: offset,
          limit: limit,
        );
        return (page.items, page.total);
      },
      columns: [
        EntityColumn('Code', (c) => c.code),
        EntityColumn('Name', (c) => c.name, flex: 3),
        EntityColumn('City', (c) => c.city, flex: 2),
        EntityColumn('VAT', (c) => c.vatNumber ?? '', flex: 2),
        EntityColumn('Zone', (c) => c.priceZoneCode ?? '—'),
      ],
      createLabel: 'New customer',
      onCreate: canWrite ? () => showCustomerForm(context) : null,
      onOpen: (c) =>
          showCustomerForm(context, customer: c, readOnly: !canWrite),
    );
  }
}
