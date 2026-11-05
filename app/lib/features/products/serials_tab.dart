import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/api.dart';
import '../../shared/actions.dart';
import '../../shared/entity_list.dart';
import '../../shared/format.dart';
import '../../shared/search_picker.dart';

/// Serialised units of a product.
class SerialsTab extends ConsumerStatefulWidget {
  const SerialsTab({super.key, required this.product});
  final Product product;

  @override
  ConsumerState<SerialsTab> createState() => _SerialsTabState();
}

class _SerialsTabState extends ConsumerState<SerialsTab> {
  @override
  Widget build(BuildContext context) {
    final api = ref.watch(apiProvider);
    final canWrite =
        ref.watch(meProvider).value?.permissions.contains('serials.write') ??
        false;
    return EntityList<SerialUnit>(
      title: 'Serial numbers',
      load: (q, offset, limit) async {
        final page = await api.engineering.listSerials(
          productId: widget.product.id,
          q: q,
          offset: offset,
          limit: limit,
        );
        return (page.items, page.total);
      },
      columns: [
        EntityColumn('Serial number', (s) => s.serialNumber, flex: 2),
        EntityColumn('Status', (s) => s.status),
        EntityColumn('BOM rev.', (s) => s.bomRevision?.toString() ?? ''),
        EntityColumn('Built into', (s) => s.parentSerialNumber ?? '', flex: 2),
        EntityColumn('Customer', (s) => s.customerName ?? '', flex: 2),
      ],
      createLabel: 'Register unit',
      onCreate: canWrite
          ? () async {
              final serial = await askText(
                context,
                title: 'Register ${widget.product.code}',
                label: 'Serial number',
              );
              if (serial == null || serial.isEmpty || !context.mounted) {
                return false;
              }
              SerialUnitDetail? created;
              final ok = await runAction(
                context,
                () async => created = await api.engineering.createSerial(
                  id: widget.product.id,
                  body: SerialInput(serialNumber: serial),
                ),
              );
              if (ok && context.mounted) {
                await showSerialUnit(context, created!.unit.id);
              }
              return ok;
            }
          : null,
      onOpen: (s) => showSerialUnit(context, s.id),
    );
  }
}

/// Shows a serial unit with its as-built components and history. Returns true if it changed.
Future<bool?> showSerialUnit(BuildContext context, String id) =>
    showDialog<bool>(
      context: context,
      builder: (_) => SerialUnitDialog(id: id),
    );

const _settableStatuses = ['in_stock', 'delivered', 'installed', 'scrapped'];

class SerialUnitDialog extends ConsumerStatefulWidget {
  const SerialUnitDialog({super.key, required this.id});
  final String id;

  @override
  ConsumerState<SerialUnitDialog> createState() => _SerialUnitDialogState();
}

class _SerialUnitDialogState extends ConsumerState<SerialUnitDialog> {
  SerialUnitDetail? _d;
  bool _changed = false;

  TraydcraftApi get _api => ref.read(apiProvider);

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final d = await _api.engineering.getSerial(id: widget.id);
    if (mounted) setState(() => _d = d);
  }

  Future<void> _apply(Future<SerialUnitDetail> Function() action) async {
    SerialUnitDetail? d;
    if (await runAction(context, () async => d = await action())) {
      setState(() {
        _d = d;
        _changed = true;
      });
    }
  }

  Future<void> _changeStatus(String status) async {
    String? customerId = _d!.unit.customerId;
    if ((status == 'delivered' || status == 'installed') &&
        customerId == null) {
      customerId = await showDialog<String>(
        context: context,
        builder: (_) => const _CustomerPicker(),
      );
      if (customerId == null) return;
    }
    await _apply(
      () => _api.engineering.setStatus(
        id: widget.id,
        body: SerialStatusInput(status: status, customerId: customerId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = _d;
    final canWrite =
        ref.watch(meProvider).value?.permissions.contains('serials.write') ??
        false;
    final theme = Theme.of(context);
    if (d == null) {
      return const AlertDialog(
        content: SizedBox(
          height: 80,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    final u = d.unit;
    final builtIn = u.parentId != null;
    return AlertDialog(
      title: Text('${u.productCode} · ${u.serialNumber}'),
      content: SizedBox(
        width: 640,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: [
                  InfoItem('Product', u.productName),
                  InfoItem('Status', u.status),
                  InfoItem('BOM revision', u.bomRevision?.toString() ?? ''),
                  InfoItem('Customer', u.customerName ?? ''),
                  if (builtIn)
                    InfoItem('Built into', u.parentSerialNumber ?? ''),
                  InfoItem('Registered', date(u.createdAt)),
                ],
              ),
              if (canWrite && !builtIn && u.status != 'scrapped')
                Wrap(
                  spacing: 8,
                  children: [
                    for (final s in _settableStatuses.where(
                      (s) => s != u.status,
                    ))
                      OutlinedButton(
                        onPressed: () => _changeStatus(s),
                        child: Text('→ $s'),
                      ),
                  ],
                ),
              const Divider(height: 32),
              Text('Components (as built)', style: theme.textTheme.titleMedium),
              if (d.components.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('No serialised components.'),
                ),
              for (final c in d.components)
                Padding(
                  padding: EdgeInsets.only(left: (c.level - 1) * 24.0),
                  child: ListTile(
                    dense: true,
                    leading: const Icon(Icons.memory_outlined),
                    title: Text('${c.productCode} · ${c.serialNumber}'),
                    subtitle: Text(
                      '${c.productName} · since ${date(c.addedAt)}',
                    ),
                    trailing: canWrite && c.parentId == u.id
                        ? PopupMenuButton<String>(
                            tooltip: 'Remove',
                            icon: const Icon(Icons.link_off),
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                value: 'in_stock',
                                child: Text('Remove, back to stock'),
                              ),
                              PopupMenuItem(
                                value: 'scrapped',
                                child: Text('Remove and scrap'),
                              ),
                            ],
                            onSelected: (status) => _apply(
                              () => _api.engineering.detachComponent(
                                id: u.id,
                                childId: c.id,
                                body: DetachInput(childStatus: status),
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              if (canWrite && u.status != 'scrapped') ...[
                const SizedBox(height: 8),
                SearchPicker<SerialUnit>(
                  label: 'Add component by serial number (in stock)',
                  clearOnSelect: true,
                  display: (s) => '${s.productCode} · ${s.serialNumber}',
                  search: (q) async => (await _api.engineering.listSerials(
                    q: q,
                    status: 'in_stock',
                    limit: 20,
                  )).items.where((s) => s.id != u.id).toList(),
                  onSelected: (s) => _apply(
                    () => _api.engineering.attachComponent(
                      id: u.id,
                      body: AttachInput(childId: s.id),
                    ),
                  ),
                ),
              ],
              if (d.history.any((h) => h.removedAt != null)) ...[
                const Divider(height: 32),
                Text('Component history', style: theme.textTheme.titleMedium),
                for (final h in d.history)
                  ListTile(
                    dense: true,
                    title: Text('${h.productCode} · ${h.serialNumber}'),
                    subtitle: Text(
                      'added ${date(h.addedAt)} by ${h.addedByName}'
                      '${h.removedAt == null ? '' : ' · removed ${date(h.removedAt)} by ${h.removedByName ?? ''}'}',
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, _changed),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _CustomerPicker extends ConsumerWidget {
  const _CustomerPicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) => AlertDialog(
    title: const Text('Customer'),
    content: SizedBox(
      width: 420,
      child: SearchPicker<Customer>(
        label: 'Customer',
        display: (c) => '${c.code} · ${c.name}',
        search: (q) async =>
            (await ref.read(apiProvider).crm.listCustomers(q: q, limit: 20))
                .items,
        onSelected: (c) => Navigator.pop(context, c.id),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
    ],
  );
}
