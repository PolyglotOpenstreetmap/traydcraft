import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'api.dart';
import 'session.dart';
import '../l10n/l10n.dart';

class _Dest {
  const _Dest(this.path, this.label, this.icon);
  final String path;
  final String Function(AppLocalizations l) label;
  final IconData icon;
}

final _destinations = [
  _Dest('/opportunities', (l) => l.opportunities, Icons.trending_up),
  _Dest('/quotations', (l) => l.quotations, Icons.request_quote_outlined),
  _Dest('/orders', (l) => l.orders, Icons.inventory_outlined),
  _Dest('/helpdesk', (l) => l.helpdesk, Icons.support_agent),
  _Dest('/customers', (l) => l.customers, Icons.business_outlined),
  _Dest('/products', (l) => l.products, Icons.inventory_2_outlined),
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
                for (final d in _destinations)
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
          for (final d in _destinations)
            NavigationDestination(
              icon: Icon(d.icon),
              label: d.label(context.l10n),
            ),
        ],
      ),
    );
  }
}
