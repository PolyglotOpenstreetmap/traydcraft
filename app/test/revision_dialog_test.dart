import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:traydcraft_app/app/api.dart';
import 'package:traydcraft_app/features/quotations/quotation_screen.dart';

class _Fake implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions o,
    Stream<Uint8List>? body,
    Future<void>? cancel,
  ) async {
    final json = {
      'old_price_date': '2025-06-01',
      'new_price_date': '2026-11-05',
      'old_subtotal': '3538.56',
      'new_subtotal': '3686.00',
      'difference': '147.44',
      'lines': [
        {
          'position': 1,
          'product_code': 'UNIT-100',
          'description': 'Process unit 100',
          'quantity': '1',
          'pricing_type': 'list',
          'old_list_unit_price': '3724.80',
          'new_list_unit_price': '3880.00',
          'old_rebate_percent': '5',
          'new_rebate_percent': '5',
          'old_line_total': '3538.56',
          'new_line_total': '3686.00',
          'difference': '147.44',
          'needs_confirmation': false,
        },
      ],
    };
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

Quotation _quotation() => Quotation.fromJson({
  'id': 'q1',
  'company_id': 'co',
  'number': 'Q2026-00007',
  'revision': 1,
  'status': 'sent',
  'customer_id': 'c1',
  'customer_name': 'Alpha',
  'customer_street': '',
  'customer_postal_code': '',
  'customer_city': '',
  'customer_country_code': 'BE',
  'customer_language': 'nl',
  'price_zone_code': 'Z2',
  'customer_discount_percent': '5',
  'currency': 'EUR',
  'quote_date': '2026-11-01',
  'price_date': '2025-06-01',
  'valid_until': '2026-12-01',
  'notes': '',
  'subtotal': '3538.56',
  'vat_total': '743.10',
  'total': '4281.66',
  'created_by': 'u',
  'created_at': '2026-11-01T10:00:00Z',
  'updated_at': '2026-11-01T10:00:00Z',
  'lines': [],
  'vat_groups': [],
});

void main() {
  testWidgets('shows agreed versus current prices and returns the choice', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final dio = Dio(BaseOptions(baseUrl: 'http://test'))
      ..httpClientAdapter = _Fake();
    RevisionPricing? choice;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [dioProvider.overrideWithValue(dio)],
        child: MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () async => choice = await showDialog<RevisionPricing>(
                context: context,
                builder: (_) => RevisionDialog(quotation: _quotation()),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.textContaining('price list of 01/06/2025'), findsOneWidget);
    expect(find.text('€ 3.538,56'), findsOneWidget);
    expect(find.text('€ 3.686,00'), findsOneWidget);
    expect(find.textContaining('(€ 147,44)'), findsOneWidget);

    await tester.tap(find.text('Keep agreed prices'));
    await tester.pumpAndSettle();
    expect(choice, RevisionPricing.keep);
  });
}
