import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:traydcraft_app/app/api.dart';
import 'package:traydcraft_app/features/orders/order_screen.dart';
import 'package:traydcraft_app/features/orders/orders_page.dart';
import 'package:traydcraft_app/l10n/app_localizations.dart';

import 'fake_http.dart';

Map<String, Object?> _line(String pos, {String pricing = 'list'}) => {
  'position': int.parse(pos),
  'product_id': 'p$pos',
  'product_code': 'UNIT-$pos',
  'description': 'Process unit $pos',
  'unit': 'pcs',
  'quantity': '1',
  'list_unit_price': '3880.0000',
  'line_discount_percent': '0',
  'pricing_type': pricing,
  'rebate_percent': '5',
  'net_unit_price': '3686.0000',
  'line_total': '3686.00',
  'vat_rate': '21',
};

Map<String, Object?> _summary(
  String status, {
  String priority = 'normal',
  int current = 1,
}) => {
  'id': 'o1',
  'number': 'O2026-00001',
  'status': status,
  'current_revision': current,
  'priority': priority,
  'quotation_id': 'q1',
  'quotation_number': 'Q2026-00001',
  'quotation_revision': 1,
  'customer_id': 'c1',
  'customer_name': 'Alpha Installaties NV',
  'customer_reference': 'PO-77',
  'order_date': '2026-11-06',
  'salesperson_id': 'u',
  'salesperson_name': 'Sales',
  'currency': 'EUR',
  'subtotal': '3686.00',
  'total': '4460.06',
};

Map<String, Object?> _order(
  String status, {
  String priority = 'normal',
  bool net = false,
  int revision = 1,
  int current = 1,
}) => {
  'order': _summary(status, priority: priority, current: current),
  'revision': revision,
  'revision_status': status,
  'created_at': '2026-11-06T09:00:00Z',
  'notes': 'Deliver on pallets',
  'cancel_reason': status == 'cancelled' ? 'Customer withdrew' : '',
  'confirmation_note': status == 'confirmed' ? 'By phone' : '',
  'confirmed_at': status == 'confirmed' ? '2026-11-07T09:00:00Z' : null,
  'confirmed_by': status == 'confirmed' ? 'u' : null,
  'confirmed_revision': status == 'confirmed' ? 1 : null,
  'confirmed_via': status == 'confirmed' ? 'staff' : null,
  'vat_total': '774.06',
  'lines': [_line('1', pricing: net ? 'net' : 'list')],
  'revisions': [
    for (var r = 1; r <= current; r++)
      {
        'revision': r,
        'status': r == current ? status : 'superseded',
        'created_at': '2026-11-06T09:00:00Z',
        'sent_at': null,
        'sent_to': null,
        'subtotal': '3686.00',
        'total': '4460.06',
      },
  ],
};

Map<String, Object?> _request({String status = 'open'}) => {
  'id': 'r1',
  'order_id': 'o1',
  'requested_by_contact_id': 'p1',
  'requested_by_name': 'Sofie Maes',
  'requested_priority': 'expedite',
  'message': 'We need it next week',
  'status': status,
  'resolution_note': '',
  'created_at': '2026-11-08T09:00:00Z',
  'resolved_at': null,
};

FakeHttp _http(
  String status, {
  String priority = 'normal',
  List<String> perms = const ['orders.read', 'orders.write'],
  bool net = false,
  int current = 1,
  List<Object?> requests = const [],
}) => FakeHttp({
  'GET /api/v1/me': (_) => meJson(perms),
  'GET /api/v1/orders/o1': (_) => _order(
    status,
    priority: priority,
    net: net,
    current: current,
    revision: current,
  ),
  'GET /api/v1/orders/o1/revisions/1': (_) =>
      _order('superseded', current: current),
  'GET /api/v1/orders/o1/priority-history': (_) => [
    {
      'id': 'h1',
      'old_priority': 'normal',
      'new_priority': 'expedite',
      'reason': 'Key account',
      'changed_by': 'u',
      'changed_by_name': 'Sales',
      'changed_at': '2026-11-07T09:00:00Z',
    },
  ],
  'GET /api/v1/orders/o1/priority-requests': (_) => requests,
  'PUT /api/v1/orders/o1': (_) => _order('draft'),
  'POST /api/v1/orders/o1/send': (_) => _order('sent'),
  'POST /api/v1/orders/o1/revisions': (_) =>
      _order('draft', current: 2, revision: 2),
  'POST /api/v1/orders/o1/confirm': (_) => _order('confirmed'),
  'POST /api/v1/orders/o1/cancel': (_) => _order('cancelled'),
  'PUT /api/v1/orders/o1/priority': (_) => _order(status, priority: 'expedite'),
  'POST /api/v1/orders/o1/priority-requests/r1/dismiss': (_) =>
      _request(status: 'dismissed'),
});

Future<void> _pump(WidgetTester tester, FakeHttp http, Widget home) async {
  tester.view.physicalSize = const Size(1400, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final router = GoRouter(
    routes: [GoRoute(path: '/', builder: (_, _) => home)],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [dioProvider.overrideWithValue(fakeDio(http))],
      child: MaterialApp.router(
        routerConfig: router,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<FakeHttp> _screen(
  WidgetTester tester,
  String status, {
  String priority = 'normal',
  List<String> perms = const ['orders.read', 'orders.write'],
  bool net = false,
  int current = 1,
  List<Object?> requests = const [],
}) async {
  final http = _http(
    status,
    priority: priority,
    perms: perms,
    net: net,
    current: current,
    requests: requests,
  );
  await _pump(tester, http, const OrderScreen(id: 'o1'));
  return http;
}

void main() {
  testWidgets('a draft can be edited and sent, not revised or confirmed', (
    tester,
  ) async {
    await _screen(tester, 'draft');
    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Send order confirmation'), findsOneWidget);
    expect(find.text('New revision'), findsNothing);
    expect(find.text('Confirm on behalf of customer'), findsNothing);
    expect(find.text('Revision 1'), findsWidgets);
  });

  testWidgets('editing a draft puts quantities and discounts in the PUT', (
    tester,
  ) async {
    final http = await _screen(tester, 'draft');
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    // Fields: reference, notes, description, quantity, discount.
    await tester.enterText(find.widgetWithText(TextField, '1'), '3');
    await tester.enterText(find.widgetWithText(TextField, '0'), '2,5');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final body = http.bodies['PUT /api/v1/orders/o1'] as Map;
    final line = (body['lines'] as List).single as Map;
    expect(line['quantity'], '3');
    expect(line['line_discount_percent'], '2.5');
    expect(line['position'], 1);
    expect(body['notes'], 'Deliver on pallets');
    expect(find.text('Order saved.'), findsOneWidget);
  });

  testWidgets('net-priced lines have no discount field', (tester) async {
    final http = await _screen(tester, 'draft', net: true);
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    final body = http.bodies['PUT /api/v1/orders/o1'] as Map;
    expect(
      ((body['lines'] as List).single as Map)['line_discount_percent'],
      isNull,
    );
  });

  testWidgets('removing a line leaves it out of the PUT', (tester) async {
    final http = await _screen(tester, 'draft');
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Remove line'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    final body = http.bodies['PUT /api/v1/orders/o1'] as Map;
    expect(body['lines'], isEmpty);
  });

  testWidgets('sending the order confirmation posts to /send', (tester) async {
    final http = await _screen(tester, 'draft');
    await tester.tap(find.text('Send order confirmation'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Send'));
    await tester.pumpAndSettle();
    expect(http.requests, contains('POST /api/v1/orders/o1/send'));
    expect(find.text('Order confirmation queued for sending.'), findsOneWidget);
  });

  testWidgets('a refused send shows the server message', (tester) async {
    final http = _http('draft');
    // Without a route the fake answers with an error body, like a refused send.
    http.routes.remove('POST /api/v1/orders/o1/send');
    await _pump(tester, http, const OrderScreen(id: 'o1'));
    await tester.tap(find.text('Send order confirmation'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Send'));
    await tester.pumpAndSettle();
    expect(find.textContaining('POST /api/v1/orders/o1/send'), findsOneWidget);
  });

  testWidgets('a sent order offers new revision and confirm, not edit', (
    tester,
  ) async {
    await _screen(tester, 'sent');
    expect(find.text('New revision'), findsOneWidget);
    expect(find.text('Confirm on behalf of customer'), findsOneWidget);
    expect(find.text('Edit'), findsNothing);
    expect(find.text('Send order confirmation'), findsNothing);
  });

  testWidgets('a new revision is requested and shown', (tester) async {
    final http = await _screen(tester, 'sent');
    await tester.tap(find.text('New revision'));
    await tester.pumpAndSettle();
    expect(http.requests, contains('POST /api/v1/orders/o1/revisions'));
    expect(find.text('Edit'), findsOneWidget);
  });

  testWidgets('confirming on behalf posts the note and revision', (
    tester,
  ) async {
    final http = await _screen(tester, 'sent');
    await tester.tap(find.text('Confirm on behalf of customer'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, ' By phone ');
    await tester.tap(find.widgetWithText(FilledButton, 'OK'));
    await tester.pumpAndSettle();
    final body = http.bodies['POST /api/v1/orders/o1/confirm'] as Map;
    expect(body['note'], 'By phone');
    expect(body['revision'], 1);
    expect(find.text('Order confirmed.'), findsOneWidget);
  });

  testWidgets('a confirmed order cannot be revised and shows confirmation', (
    tester,
  ) async {
    await _screen(tester, 'confirmed');
    expect(find.text('New revision'), findsNothing);
    expect(find.text('Edit'), findsNothing);
    expect(find.text('Confirm on behalf of customer'), findsNothing);
    expect(find.text('Cancel order'), findsOneWidget);
    expect(find.text('staff, on behalf of the customer'), findsOneWidget);
    expect(find.text('By phone'), findsOneWidget);
  });

  testWidgets('cancelling needs a reason and posts it', (tester) async {
    final http = await _screen(tester, 'confirmed');
    await tester.tap(find.text('Cancel order'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'OK'));
    await tester.pumpAndSettle();
    expect(find.text('A reason is required.'), findsOneWidget);
    expect(http.requests, isNot(contains('POST /api/v1/orders/o1/cancel')));

    await tester.enterText(find.byType(TextField).last, 'Customer withdrew');
    await tester.tap(find.widgetWithText(FilledButton, 'OK'));
    await tester.pumpAndSettle();
    final body = http.bodies['POST /api/v1/orders/o1/cancel'] as Map;
    expect(body['reason'], 'Customer withdrew');
  });

  testWidgets('a cancelled order is read-only and shows the reason', (
    tester,
  ) async {
    await _screen(tester, 'cancelled');
    expect(find.text('Cancelled: Customer withdrew'), findsOneWidget);
    expect(find.text('Cancel order'), findsNothing);
    expect(find.text('Edit'), findsNothing);
    expect(find.text('New revision'), findsNothing);
    expect(find.text('Change priority'), findsNothing);
  });

  testWidgets('without orders.write there are no write actions', (
    tester,
  ) async {
    await _screen(tester, 'sent', perms: ['orders.read']);
    expect(find.text('New revision'), findsNothing);
    expect(find.text('Confirm on behalf of customer'), findsNothing);
    expect(find.text('Cancel order'), findsNothing);
    expect(find.text('Change priority'), findsNothing);
    expect(find.text('PDF'), findsOneWidget);
  });

  testWidgets('an older revision opens read-only', (tester) async {
    final http = await _screen(tester, 'sent', current: 2);
    await tester.tap(find.textContaining('Revision 1 ·'));
    await tester.pumpAndSettle();
    expect(http.requests, contains('GET /api/v1/orders/o1/revisions/1'));
    expect(find.textContaining('You are viewing revision 1'), findsOneWidget);
    expect(find.text('New revision'), findsNothing);
    expect(find.text('Confirm on behalf of customer'), findsNothing);
    await tester.tap(find.text('Back to current revision'));
    await tester.pumpAndSettle();
    expect(find.text('New revision'), findsOneWidget);
  });

  testWidgets('changing the priority requires a reason', (tester) async {
    final http = await _screen(tester, 'confirmed');
    expect(find.text('normal'), findsWidgets);
    expect(find.textContaining('normal → expedite by Sales'), findsOneWidget);

    await tester.tap(find.text('Change priority'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'OK'));
    await tester.pumpAndSettle();
    expect(find.text('A reason is required.'), findsOneWidget);
    expect(http.requests, isNot(contains('PUT /api/v1/orders/o1/priority')));

    await tester.enterText(find.byType(TextField).last, 'Key account');
    await tester.tap(find.widgetWithText(FilledButton, 'OK'));
    await tester.pumpAndSettle();
    final body = http.bodies['PUT /api/v1/orders/o1/priority'] as Map;
    expect(body['priority'], 'expedite');
    expect(body['reason'], 'Key account');
    expect(body['request_id'], isNull);
  });

  testWidgets('applying a customer request sends its message and id', (
    tester,
  ) async {
    final http = await _screen(tester, 'confirmed', requests: [_request()]);
    expect(find.text('Sofie Maes asks for priority: expedite'), findsOneWidget);
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();
    final body = http.bodies['PUT /api/v1/orders/o1/priority'] as Map;
    expect(body['priority'], 'expedite');
    expect(body['reason'], 'We need it next week');
    expect(body['request_id'], 'r1');
    // The list refreshes afterwards.
    expect(
      http.requests.where(
        (r) => r == 'GET /api/v1/orders/o1/priority-requests',
      ),
      hasLength(2),
    );
  });

  testWidgets('dismissing a customer request posts the note', (tester) async {
    final http = await _screen(tester, 'confirmed', requests: [_request()]);
    await tester.tap(find.text('Dismiss'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Not possible');
    await tester.tap(find.widgetWithText(FilledButton, 'OK'));
    await tester.pumpAndSettle();
    const key = 'POST /api/v1/orders/o1/priority-requests/r1/dismiss';
    expect((http.bodies[key] as Map)['note'], 'Not possible');
  });

  testWidgets('the order list filters on status and shows priority', (
    tester,
  ) async {
    final http = FakeHttp({
      'GET /api/v1/orders': (_) => {
        'items': [_summary('sent', priority: 'expedite', current: 2)],
        'total': 1,
        'limit': 50,
        'offset': 0,
      },
    });
    await _pump(tester, http, const Scaffold(body: OrdersPage()));
    expect(find.text('O2026-00001  r2'), findsOneWidget);
    expect(find.text('expedite'), findsOneWidget);
    expect(find.text('sent'), findsOneWidget);

    await tester.tap(find.text('All statuses'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('confirmed').last);
    await tester.pumpAndSettle();
    expect(http.queries.first['status'], isNull);
    expect(http.queries.last['status'], 'confirmed');
  });
}
