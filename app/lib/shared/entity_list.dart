import 'dart:async';

import 'package:flutter/material.dart';

import '../app/api.dart';

/// Column of a generic entity list.
class EntityColumn<T> {
  const EntityColumn(
    this.label,
    this.value, {
    this.numeric = false,
    this.flex = 1,
  });
  final String label;
  final String Function(T item) value;
  final bool numeric;
  final int flex;
}

typedef PageLoader<T> = Future<(List<T>, int)> Function(
  String? query,
  int offset,
  int limit,
);

/// Searchable, paged list used for every master-data and document list.
///
/// One widget, configured per entity, instead of a hand-written screen per table.
/// [onOpen] and [onCreate] return `true` when data changed, which reloads the list.
class EntityList<T> extends StatefulWidget {
  const EntityList({
    super.key,
    required this.title,
    required this.load,
    required this.columns,
    this.onOpen,
    this.onCreate,
    this.createLabel = 'New',
    this.filters,
  });

  final String title;
  final PageLoader<T> load;
  final List<EntityColumn<T>> columns;
  final Future<bool?> Function(T item)? onOpen;
  final Future<bool?> Function()? onCreate;
  final String createLabel;
  final Widget? filters;

  @override
  State<EntityList<T>> createState() => EntityListState<T>();
}

class EntityListState<T> extends State<EntityList<T>> {
  static const _pageSize = 50;
  final _search = TextEditingController();
  Timer? _debounce;
  List<T> _items = [];
  int _total = 0;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    reload();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  Future<void> reload() => _fetch(reset: true);

  Future<void> _fetch({required bool reset}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final q = _search.text.trim();
      final (items, total) = await widget.load(
        q.isEmpty ? null : q,
        reset ? 0 : _items.length,
        _pageSize,
      );
      if (!mounted) return;
      setState(() {
        _items = reset ? items : [..._items, ...items];
        _total = total;
      });
    } catch (e) {
      if (mounted) setState(() => _error = errorMessage(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onSearchChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), reload);
  }

  Future<void> _after(Future<bool?>? action) async {
    if (action != null && await action == true) await reload();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wide = MediaQuery.sizeOf(context).width >= 700;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(widget.title, style: theme.textTheme.headlineSmall),
              const Spacer(),
              if (widget.onCreate != null)
                FilledButton.icon(
                  onPressed: () => _after(widget.onCreate!()),
                  icon: const Icon(Icons.add),
                  label: Text(widget.createLabel),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _search,
                  onChanged: _onSearchChanged,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search',
                  ),
                ),
              ),
              if (widget.filters != null) ...[
                const SizedBox(width: 12),
                widget.filters!,
              ],
              const SizedBox(width: 12),
              Text('${_items.length} of $_total'),
            ],
          ),
          const SizedBox(height: 8),
          if (_error != null)
            MaterialBanner(
              content: Text(_error!),
              actions: [
                TextButton(onPressed: reload, child: const Text('Retry')),
              ],
            ),
          if (_loading) const LinearProgressIndicator(),
          if (wide) _header(theme),
          Expanded(
            child: ListView.separated(
              itemCount: _items.length + 1,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                if (i == _items.length) return _footer();
                final item = _items[i];
                final onTap = widget.onOpen == null
                    ? null
                    : () => _after(widget.onOpen!(item));
                return wide ? _row(item, onTap) : _tile(item, onTap);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _cell(EntityColumn<T> c, Widget child) => Expanded(
    flex: c.flex,
    child: Align(
      alignment: c.numeric ? Alignment.centerRight : Alignment.centerLeft,
      child: child,
    ),
  );

  Widget _header(ThemeData theme) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: Row(
      children: [
        for (final c in widget.columns)
          _cell(c, Text(c.label, style: theme.textTheme.labelLarge)),
      ],
    ),
  );

  Widget _row(T item, VoidCallback? onTap) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          for (final c in widget.columns)
            _cell(c, Text(c.value(item), overflow: TextOverflow.ellipsis)),
        ],
      ),
    ),
  );

  Widget _tile(T item, VoidCallback? onTap) {
    final cols = widget.columns;
    return ListTile(
      onTap: onTap,
      title: Text(cols.length > 1 ? cols[1].value(item) : cols[0].value(item)),
      subtitle: Text(
        cols
            .where((c) => c != cols[1])
            .map((c) => c.value(item))
            .where((s) => s.isNotEmpty)
            .join(' · '),
      ),
    );
  }

  Widget _footer() => Padding(
    padding: const EdgeInsets.all(12),
    child: Center(
      child: _items.length < _total
          ? TextButton(
              onPressed: _loading ? null : () => _fetch(reset: false),
              child: const Text('Load more'),
            )
          : const SizedBox.shrink(),
    ),
  );
}
