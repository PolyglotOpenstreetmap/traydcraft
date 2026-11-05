import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/api.dart';
import '../../shared/entity_list.dart';
import '../../shared/format.dart';

class QuotationsPage extends ConsumerStatefulWidget {
  const QuotationsPage({super.key});

  @override
  ConsumerState<QuotationsPage> createState() => _QuotationsPageState();
}

class _QuotationsPageState extends ConsumerState<QuotationsPage> {
  final _list = GlobalKey<EntityListState<QuotationSummary>>();
  QuotationStatus? _status;

  @override
  Widget build(BuildContext context) {
    final api = ref.watch(apiProvider);
    final canWrite =
        ref.watch(meProvider).value?.permissions.contains('quotations.write') ??
        false;
    return EntityList<QuotationSummary>(
      key: _list,
      title: 'Quotations',
      load: (q, offset, limit) async {
        final page = await api.sales.listQuotations(
          q: q,
          status: _status?.json,
          offset: offset,
          limit: limit,
        );
        return (page.items, page.total);
      },
      filters: DropdownButton<QuotationStatus?>(
        value: _status,
        hint: const Text('All statuses'),
        items: [
          const DropdownMenuItem(value: null, child: Text('All statuses')),
          for (final s in QuotationStatus.values.where(
            (s) => s != QuotationStatus.$unknown,
          ))
            DropdownMenuItem(value: s, child: Text(s.json!)),
        ],
        onChanged: (s) {
          setState(() => _status = s);
          _list.currentState?.reload();
        },
      ),
      columns: [
        EntityColumn('Number', (q) => '${q.number}  r${q.revision}', flex: 2),
        EntityColumn('Customer', (q) => q.customerName, flex: 3),
        EntityColumn('Date', (q) => date(q.quoteDate)),
        EntityColumn('Status', (q) => q.status.json ?? ''),
        EntityColumn(
          'Total excl. VAT',
          (q) => money(q.subtotal, currency: q.currency),
          numeric: true,
          flex: 2,
        ),
      ],
      createLabel: 'New quotation',
      onCreate: canWrite
          ? () async => await context.push<bool>('/quotations/new') ?? true
          : null,
      onOpen: (q) async =>
          await context.push<bool>('/quotations/${q.id}') ?? true,
    );
  }
}
