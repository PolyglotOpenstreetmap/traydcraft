import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/customers/customers_page.dart';
import '../features/login/login_page.dart';
import '../features/products/products_page.dart';
import '../features/quotations/quotation_screen.dart';
import '../features/quotations/quotations_page.dart';
import 'session.dart';
import 'shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final signedIn = ValueNotifier(ref.read(sessionProvider).isSignedIn);
  ref.listen(sessionProvider, (_, s) => signedIn.value = s.isSignedIn);
  ref.onDispose(signedIn.dispose);

  return GoRouter(
    initialLocation: '/quotations',
    refreshListenable: signedIn,
    redirect: (context, state) {
      final atLogin = state.matchedLocation == '/login';
      if (!signedIn.value) return atLogin ? null : '/login';
      return atLogin ? '/quotations' : null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, _) => const LoginPage()),
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(
            path: '/quotations',
            builder: (_, _) => const QuotationsPage(),
          ),
          GoRoute(
            path: '/quotations/new',
            builder: (_, _) => const QuotationScreen(),
          ),
          GoRoute(
            path: '/quotations/:id',
            builder: (_, s) => QuotationScreen(id: s.pathParameters['id']),
          ),
          GoRoute(path: '/customers', builder: (_, _) => const CustomersPage()),
          GoRoute(path: '/products', builder: (_, _) => const ProductsPage()),
        ],
      ),
    ],
  );
});
