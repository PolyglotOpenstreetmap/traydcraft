import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../api/generated/export.dart';
import '../l10n/l10n.dart';
import 'portal_pages.dart';
import 'portal_state.dart';

final portalRouterProvider = Provider<GoRouter>((ref) {
  final signedIn = ValueNotifier(ref.read(portalTokenProvider) != null);
  ref.listen(portalTokenProvider, (_, t) => signedIn.value = t != null);
  ref.onDispose(signedIn.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: signedIn,
    redirect: (context, state) {
      final atLogin = state.matchedLocation == '/login';
      if (!signedIn.value) return atLogin ? null : '/login';
      return atLogin ? '/' : null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, _) => const PortalLoginPage()),
      ShellRoute(
        builder: (context, state, child) => PortalShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (_, _) => const PortalTicketsPage()),
          GoRoute(
            path: '/tickets/new',
            builder: (_, _) => const PortalNewTicketPage(),
          ),
          GoRoute(
            path: '/tickets/:id',
            builder: (_, s) => PortalTicketPage(id: s.pathParameters['id']!),
          ),
          GoRoute(
            path: '/profile',
            builder: (_, _) => const PortalProfilePage(),
          ),
        ],
      ),
    ],
  );
});

/// The customer portal: sign in with an e-mailed link, see and raise tickets, set how we address you.
class PortalApp extends ConsumerWidget {
  const PortalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Customer portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF2F5D62),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          isDense: true,
        ),
      ),
      routerConfig: ref.watch(portalRouterProvider),
      locale: ref.watch(portalLocaleProvider),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      onGenerateTitle: (context) => context.l10n.portalTitle,
    );
  }
}

/// App bar and navigation around the signed-in pages. Also switches the portal to the language
/// of the person once their profile is known.
class PortalShell extends ConsumerWidget {
  const PortalShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    ref.listen<AsyncValue<PortalProfile>>(portalProfileProvider, (_, p) {
      final profile = p.value;
      if (profile != null) {
        ref
            .read(portalLocaleProvider.notifier)
            .set(Locale(profile.effectiveLanguage));
      }
    });
    final profile = ref.watch(portalProfileProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () => context.go('/'),
          child: Text(
            profile == null
                ? l.portalTitle
                : '${l.portalTitle} · ${profile.customerName}',
          ),
        ),
        actions: [
          if (profile != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  l.signedInAs(profile.fullName),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          IconButton(
            tooltip: l.myProfile,
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.go('/profile'),
          ),
          IconButton(
            tooltip: l.signOut,
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await ref.read(portalApiProvider).endSession();
              } catch (_) {
                // The session may already be gone; signing out locally is what matters.
              }
              await ref.read(portalTokenProvider.notifier).set(null);
              ref.invalidate(portalProfileProvider);
            },
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: child,
        ),
      ),
    );
  }
}
