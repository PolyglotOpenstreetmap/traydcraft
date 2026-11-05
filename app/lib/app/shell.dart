import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'api.dart';
import 'session.dart';

class _Dest {
  const _Dest(this.path, this.label, this.icon);
  final String path;
  final String label;
  final IconData icon;
}

const _destinations = [
  _Dest('/quotations', 'Quotations', Icons.request_quote_outlined),
  _Dest('/customers', 'Customers', Icons.business_outlined),
  _Dest('/products', 'Products', Icons.inventory_2_outlined),
];

/// Navigation frame: a side rail on desktop/tablet, a bottom bar on phones.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = _destinations
        .indexWhere((d) => location.startsWith(d.path))
        .clamp(0, _destinations.length - 1);
    final wide = MediaQuery.sizeOf(context).width >= 800;
    final me = ref.watch(meProvider);
    void go(int i) => context.go(_destinations[i].path);

    final userMenu = PopupMenuButton<String>(
      tooltip: 'Account',
      icon: const Icon(Icons.account_circle_outlined),
      itemBuilder: (_) => [
        PopupMenuItem(
          enabled: false,
          child: Text(
            me.when(
              data: (m) =>
                  '${m.displayName}\n${m.company.name}\n${m.roles.join(', ')}',
              loading: () => '…',
              error: (e, _) => errorMessage(e),
            ),
          ),
        ),
        const PopupMenuItem(value: 'signout', child: Text('Sign out')),
      ],
      onSelected: (v) {
        if (v == 'signout') ref.read(sessionProvider.notifier).signOut();
      },
    );

    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: index,
              onDestinationSelected: go,
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'traydcraft',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: userMenu,
                ),
              ),
              destinations: [
                for (final d in _destinations)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    label: Text(d.label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(me.value?.company.name ?? 'traydcraft'),
        actions: [userMenu],
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: go,
        destinations: [
          for (final d in _destinations)
            NavigationDestination(icon: Icon(d.icon), label: d.label),
        ],
      ),
    );
  }
}
