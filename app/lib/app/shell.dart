import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'api.dart';
import 'session.dart';
import '../l10n/l10n.dart';

class _Dest {
  const _Dest(this.path, this.label, this.icon, this.permission);
  final String path;
  final String Function(AppLocalizations l) label;
  final IconData icon;

  /// The permission that makes the section useful; people without it do not see the tab.
  final String permission;
}

final _allDestinations = [
  _Dest(
    '/opportunities',
    (l) => l.opportunities,
    Icons.trending_up,
    'opportunities.read',
  ),
  _Dest(
    '/quotations',
    (l) => l.quotations,
    Icons.request_quote_outlined,
    'quotations.read',
  ),
  _Dest('/orders', (l) => l.orders, Icons.inventory_outlined, 'orders.read'),
  _Dest('/helpdesk', (l) => l.helpdesk, Icons.support_agent, 'helpdesk.read'),
  _Dest('/kb', (l) => l.kbTitle, Icons.menu_book_outlined, 'kb.read'),
  _Dest(
    '/repairs',
    (l) => l.repairs,
    Icons.build_circle_outlined,
    'repairs.read',
  ),
  _Dest('/jobs', (l) => l.jobs, Icons.engineering_outlined, 'field.read'),
  _Dest(
    '/stock',
    (l) => l.stockTitle,
    Icons.warehouse_outlined,
    'inventory.read',
  ),
  _Dest(
    '/customers',
    (l) => l.customers,
    Icons.business_outlined,
    'customers.read',
  ),
  _Dest(
    '/products',
    (l) => l.products,
    Icons.inventory_2_outlined,
    'products.read',
  ),
];

/// Navigation frame: a side rail on desktop/tablet, a bottom bar on phones.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wide = MediaQuery.sizeOf(context).width >= 800;
    final me = ref.watch(meProvider);
    // Show the sections the user has rights for (all, while the user is still loading), so a
    // technician sees "My jobs" and not a row of tabs that answer "forbidden".
    final perms = me.value?.permissions;
    final destinations = [
      for (final d in _allDestinations)
        if (perms == null || perms.contains(d.permission)) d,
    ];
    final found = destinations.indexWhere((d) => location.startsWith(d.path));
    if (found < 0 && destinations.isNotEmpty && perms != null) {
      // The current page is not for this user (e.g. the default start page): go to their first.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go(destinations.first.path);
      });
    }
    if (destinations.isEmpty) {
      return Scaffold(body: Center(child: Text(context.l10n.noAccess)));
    }
    final index = found < 0 ? 0 : found;
    void go(int i) => context.go(destinations[i].path);

    final userMenu = PopupMenuButton<String>(
      tooltip: context.l10n.account,
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
        const PopupMenuDivider(),
        PopupMenuItem(enabled: false, child: Text(context.l10n.appLanguage)),
        CheckedPopupMenuItem(
          value: 'lang:',
          checked: ref.watch(localeProvider) == null,
          child: Text(context.l10n.deviceLanguage),
        ),
        for (final code in languageCodes)
          CheckedPopupMenuItem(
            value: 'lang:$code',
            checked: ref.watch(localeProvider)?.languageCode == code,
            child: Text(languageName(code)),
          ),
        const PopupMenuDivider(),
        PopupMenuItem(value: 'signout', child: Text(context.l10n.signOut)),
      ],
      onSelected: (v) {
        if (v == 'signout') ref.read(sessionProvider.notifier).signOut();
        if (v.startsWith('lang:')) {
          final code = v.substring(5);
          ref
              .read(localeProvider.notifier)
              .set(code.isEmpty ? null : Locale(code));
        }
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
                for (final d in destinations)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    label: Text(d.label(context.l10n)),
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
          for (final d in destinations)
            NavigationDestination(
              icon: Icon(d.icon),
              label: d.label(context.l10n),
            ),
        ],
      ),
    );
  }
}
