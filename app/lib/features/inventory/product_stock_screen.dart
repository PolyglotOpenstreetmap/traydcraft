import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/api.dart';
import '../../l10n/l10n.dart';
import '../../shared/actions.dart';
import '../../shared/format.dart';
import '../../shared/photos.dart' show newClientId;
import '../products/product_screen.dart' show productProvider;
import 'inventory_common.dart';
import 'move_dialogs.dart';

const _pageSize = 30;

/// Stock of one product: totals, stock per location and lot, reservations and the movement
/// history, with receive/issue/transfer/adjust.
class ProductStockScreen extends ConsumerStatefulWidget {
  const ProductStockScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<ProductStockScreen> createState() => _ProductStockScreenState();
}

class _ProductStockScreenState extends ConsumerState<ProductStockScreen> {
  ProductStock? _totals;
  List<StockRow> _rows = [];
  List<ReservationRow> _reservations = [];
  final List<StockMove> _moves = [];
  int _moveTotal = 0;
  String? _error;
  bool _loading = true;
  bool _changed = false;

  TraydcraftApi get _api => ref.read(apiProvider);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final totals = await _api.inventory.listProductStock(
        productId: widget.id,
        limit: 1,
      );
      final rows = await _api.inventory.listStock(productId: widget.id);
      final reservations = await _api.inventory.listReservations(
        productId: widget.id,
      );
      final moves = await _api.inventory.listMoves(
        productId: widget.id,
        limit: _pageSize,
      );
      if (!mounted) return;
      setState(() {
        _totals = totals.items.firstOrNull;
        _rows = rows.items;
        _reservations = reservations;
        _moves
          ..clear()
          ..addAll(moves.items);
        _moveTotal = moves.total;
      });
    } catch (e) {
      if (mounted) setState(() => _error = errorMessage(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _moreMoves() async {
    final page = await _api.inventory.listMoves(
      productId: widget.id,
      limit: _pageSize,
      offset: _moves.length,
    );
    if (mounted) setState(() => _moves.addAll(page.items));
  }

  Future<void> _after(Future<bool?> action) async {
    if (await action == true) {
      _changed = true;
      ref.invalidate(productProvider(widget.id));
      await _load();
    }
  }

  Future<void> _reverse(StockMove m) async {
    final note = await askText(
      context,
      title: context.l10n.stockReverseTitle,
      label: context.l10n.stockNote,
    );
    if (note == null || !mounted) return;
    if (await runAction(
      context,
      () => _api.inventory.reverse(
        id: m.id,
        body: ReverseInput(id: newClientId(), note: note),
      ),
    )) {
      _changed = true;
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final product = ref.watch(productProvider(widget.id)).value;
    final canWrite = hasPermission(ref, 'inventory.write');
    final canAdmin = hasPermission(ref, 'inventory.admin');
    final t = _totals;
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              IconButton(
                onPressed: () => context.canPop()
                    ? context.pop(_changed)
                    : context.go('/stock'),
                icon: const Icon(Icons.arrow_back),
              ),
              Text(
                product == null ? '…' : '${product.code} · ${product.name}',
                style: theme.textTheme.headlineSmall,
              ),
              if (product != null)
                OutlinedButton.icon(
                  icon: const Icon(Icons.open_in_new),
                  label: Text(l.product),
                  onPressed: () => context.push('/products/${product.id}'),
                ),
              if (_loading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _error!,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          if (product != null && canWrite)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    icon: const Icon(Icons.move_to_inbox_outlined),
                    label: Text(l.stockReceive),
                    onPressed: () => _after(
                      showMoveDialog(
                        context,
                        MoveKind.receive,
                        product: product,
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.outbox_outlined),
                    label: Text(l.stockIssue),
                    onPressed: () => _after(
                      showMoveDialog(context, MoveKind.issue, product: product),
                    ),
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.swap_horiz),
                    label: Text(l.stockTransfer),
                    onPressed: () => _after(
                      showMoveDialog(
                        context,
                        MoveKind.transfer,
                        product: product,
                      ),
                    ),
                  ),
                  if (canAdmin && product.tracking != 'serial')
                    OutlinedButton.icon(
                      icon: const Icon(Icons.tune),
                      label: Text(l.stockAdjust),
                      onPressed: () =>
                          _after(showAdjustDialog(context, product: product)),
                    ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          if (t != null)
            Wrap(
              children: [
                InfoItem(l.stockOnHand, '${number(t.onHand)} ${t.unit}'),
                InfoItem(l.stockReserved, number(t.reserved)),
                InfoItem(l.stockAvailable, number(t.available)),
                InfoItem(l.stockInVans, number(t.inVans)),
                InfoItem(l.stockReorderMin, number(t.reorderMin)),
                InfoItem(l.stockReorderMax, number(t.reorderMax)),
                InfoItem(l.stockLeadTime, t.leadTimeDays?.toString() ?? ''),
                InfoItem(l.stockBarcode, t.barcode ?? ''),
                if (product?.standardCost != null)
                  InfoItem(l.stockStandardCost, money(product!.standardCost)),
              ],
            ),
          SectionTitle(l.stockLocations),
          if (_rows.isEmpty && !_loading) Text(l.stockNothingInStock),
          for (final r in _rows)
            ListTile(
              dense: true,
              leading: const Icon(Icons.place_outlined),
              title: Text(
                r.lotNumber == null
                    ? r.location
                    : '${r.location} · ${l.stockLot} ${r.lotNumber}',
              ),
              subtitle: Text(
                '${l.stockReserved}: ${number(r.reserved)} · '
                '${l.stockAvailable}: ${number(r.available)}'
                '${r.expiryDate == null ? '' : ' · ${l.stockExpiry}: ${date(r.expiryDate)}'}',
              ),
              trailing: Text('${number(r.onHand)} ${r.unit}'),
            ),
          if (_reservations.isNotEmpty) ...[
            SectionTitle(l.stockReservations),
            for (final r in _reservations)
              ListTile(
                dense: true,
                leading: const Icon(Icons.bookmark_outline),
                title: Text('${r.orderNumber} · ${r.customerName}'),
                subtitle: Text(
                  '${l.stockLocation}: ${r.location}'
                  '${r.lotNumber == null ? '' : ' · ${l.stockLot}: ${r.lotNumber}'}',
                ),
                trailing: Text(number(r.quantity)),
                onTap: () => context.push('/orders/${r.orderId}'),
              ),
          ],
          SectionTitle(l.stockMoves),
          if (_moves.isEmpty && !_loading) Text(l.stockNoMoves),
          for (final m in _moves)
            ListTile(
              dense: true,
              leading: Icon(
                m.kind == 'receipt'
                    ? Icons.move_to_inbox_outlined
                    : m.kind == 'issue'
                    ? Icons.outbox_outlined
                    : m.kind == 'transfer'
                    ? Icons.swap_horiz
                    : Icons.tune,
              ),
              title: Text(
                '${l.stockReason(m.reason)} · ${number(m.quantity)} ${m.unit}'
                '${m.reversedBy != null ? ' · ${l.stockReversed}' : ''}',
                style: m.reversedBy != null
                    ? const TextStyle(decoration: TextDecoration.lineThrough)
                    : null,
              ),
              subtitle: Text(
                '${m.fromLocation} → ${m.toLocation}'
                '${m.lotNumber == null ? '' : ' · ${l.stockLot} ${m.lotNumber}'}'
                '${m.serialNumber == null ? '' : ' · ${m.serialNumber}'}'
                ' · ${date(m.occurredAt)} · ${m.createdByName}'
                '${m.note.isEmpty ? '' : '\n${m.note}'}',
              ),
              isThreeLine: m.note.isNotEmpty,
              trailing: canAdmin && m.reversedBy == null && m.reversedOf == null
                  ? IconButton(
                      tooltip: l.stockReverse,
                      icon: const Icon(Icons.undo),
                      onPressed: () => _reverse(m),
                    )
                  : null,
            ),
          if (_moves.length < _moveTotal)
            Center(
              child: TextButton(onPressed: _moreMoves, child: Text(l.loadMore)),
            ),
        ],
      ),
    );
  }
}
