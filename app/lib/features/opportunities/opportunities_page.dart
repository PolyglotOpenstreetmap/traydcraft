import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/api.dart';
import '../../shared/entity_list.dart';
import '../../shared/format.dart';
import 'opportunity_form.dart';

final pipelineProvider = FutureProvider.autoDispose<List<PipelineStage>>(
  (ref) => ref.watch(apiProvider).crm.pipeline(),
);

class OpportunitiesPage extends ConsumerStatefulWidget {
  const OpportunitiesPage({super.key});

  @override
  ConsumerState<OpportunitiesPage> createState() => _OpportunitiesPageState();
}

class _OpportunitiesPageState extends ConsumerState<OpportunitiesPage> {
  final _list = GlobalKey<EntityListState<Opportunity>>();
  OpportunityStage? _stage;
  bool _openOnly = true;

  void _reload() {
    ref.invalidate(pipelineProvider);
    _list.currentState?.reload();
  }

  @override
  Widget build(BuildContext context) {
    final api = ref.watch(apiProvider);
    final canWrite =
        ref
            .watch(meProvider)
            .value
            ?.permissions
            .contains('opportunities.write') ??
        false;
    return Column(
      children: [
        _Pipeline(
          selected: _stage,
          onSelect: (s) {
            setState(() {
              _stage = _stage == s ? null : s;
              if (_stage != null) _openOnly = false;
            });
            _list.currentState?.reload();
          },
        ),
        Expanded(
          child: EntityList<Opportunity>(
            key: _list,
            title: 'Opportunities',
            load: (q, offset, limit) async {
              final page = await api.crm.listOpportunities(
                q: q,
                stage: _stage?.json,
                open: _openOnly ? true : null,
                offset: offset,
                limit: limit,
              );
              return (page.items, page.total);
            },
            filters: FilterChip(
              label: const Text('Open only'),
              selected: _openOnly,
              onSelected: (v) {
                setState(() => _openOnly = v);
                _list.currentState?.reload();
              },
            ),
            columns: [
              EntityColumn('Number', (o) => o.number),
              EntityColumn('Title', (o) => o.title, flex: 3),
              EntityColumn('Customer', (o) => o.customerName, flex: 3),
              EntityColumn('Stage', (o) => o.stage.json ?? ''),
              EntityColumn('Close', (o) => date(o.expectedClose)),
              EntityColumn(
                'Value',
                (o) => money(o.expectedValue),
                numeric: true,
                flex: 2,
              ),
              EntityColumn('Prob.', (o) => '${o.probability} %', numeric: true),
            ],
            createLabel: 'New opportunity',
            onCreate: canWrite
                ? () async {
                    final created = await showOpportunityForm(context);
                    if (created != null) _reload();
                    return false;
                  }
                : null,
            onOpen: (o) async {
              await context.push<bool>('/opportunities/${o.id}');
              _reload();
              return false;
            },
          ),
        ),
      ],
    );
  }
}

/// Pipeline summary: one card per stage; tap to filter.
class _Pipeline extends ConsumerWidget {
  const _Pipeline({required this.selected, required this.onSelect});
  final OpportunityStage? selected;
  final void Function(OpportunityStage) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stages = ref.watch(pipelineProvider).value ?? const [];
    final theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          for (final s in stages)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: SizedBox(
                width: 170,
                child: Card(
                  color: selected == s.stage
                      ? theme.colorScheme.primaryContainer
                      : null,
                  child: InkWell(
                    onTap: () => onSelect(s.stage),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${s.stage.json}  (${s.count})',
                            style: theme.textTheme.labelLarge,
                          ),
                          Text(
                            money(s.totalValue),
                            style: theme.textTheme.titleMedium,
                          ),
                          Text(
                            'weighted ${money(s.weightedValue)}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
