import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/customers/customers_page.dart';
import '../features/helpdesk/answers_page.dart';
import '../features/helpdesk/ticket_screen.dart';
import '../features/helpdesk/tickets_page.dart';
import '../features/field/job_screen.dart';
import '../features/field/jobs_page.dart';
import '../features/orders/order_screen.dart';
import '../features/orders/orders_page.dart';
import '../features/login/login_page.dart';
import '../features/opportunities/opportunities_page.dart';
import '../features/opportunities/opportunity_screen.dart';
import '../features/products/product_screen.dart';
import '../features/products/products_page.dart';
import '../features/quotations/quotation_screen.dart';
import '../features/repairs/departments_page.dart';
import '../features/repairs/repair_screen.dart';
import '../features/repairs/repairs_page.dart';
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
            builder: (_, s) => QuotationScreen(
              customerId: s.uri.queryParameters['customer'],
              opportunityId: s.uri.queryParameters['opportunity'],
            ),
          ),
          GoRoute(
            path: '/quotations/:id',
            builder: (_, s) => QuotationScreen(id: s.pathParameters['id']),
          ),
          GoRoute(path: '/helpdesk', builder: (_, _) => const TicketsPage()),
          GoRoute(
            path: '/helpdesk/answers',
            builder: (_, _) => const AnswersPage(),
          ),
          GoRoute(
            path: '/helpdesk/:id',
            builder: (_, s) => TicketScreen(id: s.pathParameters['id']!),
          ),
          GoRoute(path: '/repairs', builder: (_, _) => const RepairsPage()),
          GoRoute(
            path: '/repairs/departments',
            builder: (_, _) => const DepartmentsPage(),
          ),
          GoRoute(
            path: '/repairs/:id',
            builder: (_, s) => RepairScreen(id: s.pathParameters['id']!),
          ),
          GoRoute(path: '/jobs', builder: (_, _) => const JobsPage()),
          GoRoute(
            path: '/jobs/:id',
            builder: (_, s) => JobScreen(id: s.pathParameters['id']!),
          ),
          GoRoute(path: '/orders', builder: (_, _) => const OrdersPage()),
          GoRoute(
            path: '/orders/:id',
            builder: (_, s) => OrderScreen(id: s.pathParameters['id']!),
          ),
          GoRoute(path: '/customers', builder: (_, _) => const CustomersPage()),
          GoRoute(path: '/products', builder: (_, _) => const ProductsPage()),
          GoRoute(
            path: '/products/:id',
            builder: (_, s) => ProductScreen(id: s.pathParameters['id']!),
          ),
          GoRoute(
            path: '/opportunities',
            builder: (_, _) => const OpportunitiesPage(),
          ),
          GoRoute(
            path: '/opportunities/:id',
            builder: (_, s) => OpportunityScreen(id: s.pathParameters['id']!),
          ),
        ],
      ),
    ],
  );
});
