import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/api.dart';
import '../../l10n/l10n.dart';
import '../../shared/actions.dart';
import '../../shared/format.dart';

final _orderProvider = FutureProvider.autoDispose.family<Order, String>(
  (ref, id) => ref.watch(apiProvider).sales.getOrder(id: id),
);

/// A sales order (read-only copy of the accepted quotation). Production can ask the salesperson a
/// question about it from here.
class OrderScreen extends ConsumerWidget {
  const OrderScreen({super.key, required this.id});
  final String id;

  Future<void> _ask(BuildContext context, WidgetRef ref, OrderSummary o) async {
    final l = context.l10n;
    final subject = TextEditingController();
    final body = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.questionToSales),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l.questionToSalesHelp(o.salespersonName)),
              const SizedBox(height: 12),
              TextField(
                controller: subject,
                decoration: InputDecoration(labelText: l.subject),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: body,
                maxLines: 5,
                decoration: InputDecoration(labelText: l.question),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.send),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    TicketDetail? t;
    final done = await runAction(
      context,
      () async => t = await ref
          .read(apiProvider)
          .helpdesk
          .productionQuestion(
            body: ProductionQuestionInput(
              orderId: o.id,
              subject: subject.text.trim(),
              body: body.text.trim(),
            ),
          ),
    );
    if (done && context.mounted) context.push('/helpdesk/${t!.ticket.id}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final order = ref.watch(_orderProvider(id));
    final perms = ref.watch(meProvider).value?.permissions ?? const [];
    final theme = Theme.of(context);
    return Scaffold(
      body: order.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(errorMessage(e))),
        data: (d) {
          final o = d.order;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Wrap(
                spacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : context.go('/orders'),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text(
                    '${l.order} ${o.number}',
                    style: theme.textTheme.headlineSmall,
                  ),
                  Chip(
                    label: Text(
                      o.status == 'confirmed' ? l.confirmed : l.cancelled,
                    ),
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.request_quote_outlined),
                    label: Text(
                      '${o.quotationNumber} rev. ${o.quotationRevision}',
                    ),
                    onPressed: () =>
                        context.push('/quotations/${o.quotationId}'),
                  ),
                  if (perms.contains('helpdesk.write'))
                    FilledButton.tonalIcon(
                      icon: const Icon(Icons.help_outline),
                      label: Text(l.questionToSales),
                      onPressed: () => _ask(context, ref, o),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                children: [
                  InfoItem(l.customer, o.customerName),
                  InfoItem(l.customerReference, o.customerReference),
                  InfoItem(l.date, date(o.orderDate)),
                  InfoItem(l.salesperson, o.salespersonName),
                  InfoItem(
                    l.totalExclVat,
                    money(o.subtotal, currency: o.currency),
                  ),
                  InfoItem(
                    l.totalInclVat,
                    money(o.total, currency: o.currency),
                  ),
                ],
              ),
              if (d.notes.isNotEmpty) Text(d.notes),
              const SizedBox(height: 16),
              DataTable(
                columns: [
                  DataColumn(label: Text(l.code)),
                  DataColumn(label: Text(l.description)),
                  DataColumn(label: Text(l.quantity), numeric: true),
                  DataColumn(label: Text(l.netPrice), numeric: true),
                  DataColumn(label: Text(l.total), numeric: true),
                ],
                rows: [
                  for (final line in d.lines)
                    DataRow(
                      cells: [
                        DataCell(Text(line.productCode)),
                        DataCell(Text(line.description)),
                        DataCell(Text('${number(line.quantity)} ${line.unit}')),
                        DataCell(
                          Text(money(line.netUnitPrice, currency: o.currency)),
                        ),
                        DataCell(
                          Text(money(line.lineTotal, currency: o.currency)),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
