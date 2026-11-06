import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:traydcraft_app/app/api.dart';
import 'package:traydcraft_app/features/quotations/quotation_screen.dart';
import 'package:traydcraft_app/l10n/app_localizations.dart';

const _quotationId = 'q1';
const _customerId = 'c1';
const _productId = 'p1';

Map<String, Object?> _line(String qty, String total) => {
  'position': 1,
  'product_id': _productId,
  'product_code': 'UNIT-100',
  'description': 'Process unit 100',
  'unit': 'pcs',
  'quantity': qty,
  'list_unit_price': '3880.0000',
  'line_discount_percent': '0',
  'pricing_type': 'list',
  'rebate_percent': '5',
  'rebate_source': 'general',
  'price_confirmed': true,
  'net_unit_price': '3686.0000',
  'line_total': total,
  'vat_rate': '21',
};

Map<String, Object?> _quotation(String status) => {
  'id': _quotationId,
  'company_id': 'co',
  'number': 'Q2026-00001',
  'revision': 1,
  'status': status,
  'customer_id': _customerId,
  'customer_name': 'Alpha Installaties NV',
  'customer_vat_number': null,
  'customer_street': 'Havenlaan 10',
  'customer_postal_code': '2000',
  'customer_city': 'Antwerpen',
  'customer_country_code': 'BE',
  'customer_language': 'nl',
  'price_zone_code': 'Z2',
  'customer_discount_percent': '5',
  'currency': 'EUR',
  'quote_date': '2026-11-05',
  'price_date': '2026-11-05',
  'valid_until': '2026-12-05',
  'notes': '',
  'subtotal': '3686.00',
  'vat_total': '774.06',
  'total': '4460.06',
  'supersedes_id': null,
  'created_by': 'u',
  'created_at': '2026-11-05T10:00:00Z',
  'updated_at': '2026-11-05T10:00:00Z',
  'sent_at': null,
  'lines': [_line('1', '3686.00')],
  'vat_groups': [
    {'vat_rate': '21', 'base': '3686.00', 'vat': '774.06'},
  ],
};

/// Fake backend: records requests and answers like the Rust API would.
class FakeApi implements HttpClientAdapter {
  FakeApi(this.status);
  final String status;
  final requests = <String>[];
  final bodies = <String, Object?>{};

  @override
  Future<ResponseBody> fetch(
    RequestOptions o,
    Stream<Uint8List>? body,
    Future<void>? cancel,
  ) async {
    final key = '${o.method} ${o.path}';
    requests.add(key);
    bodies[key] = o.data == null ? null : jsonDecode(jsonEncode(o.data));
    Object? json;
    switch (key) {
      case 'GET /api/v1/quotations/$_quotationId':
        json = _quotation(status);
      case 'GET /api/v1/customers/$_customerId':
        json = {
          'id': _customerId,
          'code': 'C0001',
          'name': 'Alpha Installaties NV',
          'street': 'Havenlaan 10',
          'postal_code': '2000',
          'city': 'Antwerpen',
          'country_code': 'BE',
          'language': 'nl',
          'active': true,
          'price_zone_id': 'z2',
          'price_zone_code': 'Z2',
          'discount_percent': '5',
          'payment_terms_days': 30,
        };
      case 'GET /api/v1/products/$_productId':
        json = {
          'id': _productId,
          'code': 'UNIT-100',
          'name': 'Process unit 100',
          'description': '',
          'unit': 'pcs',
          'product_type': 'manufactured',
          'tracking': 'serial',
          'pricing_type': 'list',
          'vat_rate': '21',
          'active': true,
        };
      case 'POST /api/v1/pricing/preview':
        // The server is the only place that calculates: 2 units -> 7372.00.
        json = {
          'price_zone_code': 'Z2',
          'customer_discount_percent': '5',
          'quote_date': '2026-11-05',
          'price_date': '2026-11-05',
          'unconfirmed_lines': 0,
          'lines': [_line('2', '7372.00')],
          'vat_groups': [
            {'vat_rate': '21', 'base': '7372.00', 'vat': '1548.12'},
          ],
          'subtotal': '7372.00',
          'vat_total': '1548.12',
          'total': '8920.12',
        };
      case 'POST /api/v1/quotations/$_quotationId/convert':
        json = {
          'created_at': '2026-11-06T09:00:00Z',
          'lines': <Object?>[],
          'notes': '',
          'cancel_reason': '',
          'confirmation_note': '',
          'revision': 1,
          'revision_status': 'draft',
          'revisions': <Object?>[],
          'vat_total': '774.06',
          'order': {
            'id': 'o1',
            'number': 'O2026-00001',
            'status': 'draft',
            'current_revision': 1,
            'priority': 'normal',
            'quotation_id': _quotationId,
            'quotation_number': 'Q2026-00001',
            'quotation_revision': 1,
            'customer_id': _customerId,
            'customer_name': 'Alpha Installaties NV',
            'customer_reference': 'PO-77',
            'order_date': '2026-11-06',
            'salesperson_id': 'u',
            'salesperson_name': 'Sales',
            'currency': 'EUR',
            'subtotal': '3686.00',
            'total': '4460.06',
          },
        };
      case 'GET /api/v1/me':
        json = {
          'user_id': 'u',
          'email': 'sales@example.com',
          'display_name': 'Sales',
          'roles': ['sales'],
          'permissions': ['quotations.read', 'quotations.write'],
          'memberships': [],
          'company': {
            'id': 'co',
            'name': 'Demo',
            'street': '',
            'postal_code': '',
            'city': '',
            'country_code': 'BE',
            'currency': 'EUR',
            'default_language': 'nl',
          },
        };
      default:
        return ResponseBody.fromString(
          '{"error":"not_found","message":"$key"}',
          404,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
    }
    return ResponseBody.fromString(
      jsonEncode(json),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Future<FakeApi> _pump(WidgetTester tester, String status) async {
  tester.view.physicalSize = const Size(1400, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final fake = FakeApi(status);
  final dio = Dio(BaseOptions(baseUrl: 'http://test'))
    ..httpClientAdapter = fake;
  await tester.pumpWidget(
    ProviderScope(
      overrides: [dioProvider.overrideWithValue(dio)],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: QuotationScreen(id: _quotationId),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return fake;
}

/// Like [_pump], inside a router so the screen can navigate to the new order.
Future<FakeApi> _pumpRouted(WidgetTester tester, String status) async {
  tester.view.physicalSize = const Size(1400, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final fake = FakeApi(status);
  final dio = Dio(BaseOptions(baseUrl: 'http://test'))
    ..httpClientAdapter = fake;
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => QuotationScreen(id: _quotationId),
      ),
      GoRoute(
        path: '/orders/:id',
        builder: (_, state) => Text('order page ${state.pathParameters['id']}'),
      ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [dioProvider.overrideWithValue(dio)],
      child: MaterialApp.router(
        routerConfig: router,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return fake;
}

void main() {
  testWidgets('draft totals come from the server pricing preview', (
    tester,
  ) async {
    final fake = await _pump(tester, 'draft');
    expect(find.text('Save draft'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, '1'), '2');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    final body = fake.bodies['POST /api/v1/pricing/preview'] as Map;
    expect((body['lines'] as List).first['quantity'], '2');
    expect(find.text('€ 8.920,12'), findsOneWidget);
    expect(find.text('€ 7.372,00'), findsWidgets);
  });

  testWidgets('sent quotation is read-only with follow-up actions', (
    tester,
  ) async {
    final fake = await _pump(tester, 'sent');
    expect(find.text('Save draft'), findsNothing);
    expect(find.text('Accepted'), findsOneWidget);
    expect(find.text('New revision'), findsOneWidget);
    expect(find.text('€ 4.460,06'), findsOneWidget);
    expect(fake.requests, isNot(contains('POST /api/v1/pricing/preview')));
  });

  for (final status in ['sent', 'accepted']) {
    testWidgets('$status quotation offers Convert to order', (tester) async {
      await _pump(tester, status);
      expect(find.text('Convert to order'), findsOneWidget);
    });
  }

  for (final status in ['draft', 'rejected']) {
    testWidgets('$status quotation cannot be converted', (tester) async {
      await _pump(tester, status);
      expect(find.text('Convert to order'), findsNothing);
    });
  }

  testWidgets('Convert to order sends the reference and opens the order', (
    tester,
  ) async {
    final fake = await _pumpRouted(tester, 'sent');
    await tester.tap(find.text('Convert to order'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).last, ' PO-77 ');
    await tester.tap(find.widgetWithText(FilledButton, 'OK'));
    await tester.pumpAndSettle();

    const key = 'POST /api/v1/quotations/$_quotationId/convert';
    expect(fake.requests, contains(key));
    expect((fake.bodies[key] as Map)['customer_reference'], 'PO-77');
    expect(find.text('order page o1'), findsOneWidget);
  });

  testWidgets('cancelling the reference dialog creates no order', (
    tester,
  ) async {
    final fake = await _pumpRouted(tester, 'accepted');
    await tester.tap(find.text('Convert to order'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(
      fake.requests,
      isNot(contains('POST /api/v1/quotations/$_quotationId/convert')),
    );
    expect(find.text('order page o1'), findsNothing);
  });
}
