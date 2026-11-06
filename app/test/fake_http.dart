import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// A fake server for widget tests: [routes] maps `"METHOD /path"` to a JSON body (or a function
/// of the request body). Unknown routes answer 404. Requests are recorded.
class FakeHttp implements HttpClientAdapter {
  FakeHttp(this.routes);

  final Map<String, Object? Function(Object? body)> routes;
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
    Object? sent;
    if (body != null) {
      final raw = utf8.decode(await body.expand((c) => c).toList());
      if (raw.isNotEmpty) sent = jsonDecode(raw);
    }
    bodies[key] = sent;
    final route = routes[key];
    if (route == null) {
      return ResponseBody.fromString(
        jsonEncode({'error': 'not_found', 'message': key}),
        404,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }
    final json = route(sent);
    return ResponseBody.fromString(
      jsonEncode(json),
      json == null ? 204 : 200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio fakeDio(FakeHttp http) =>
    Dio(BaseOptions(baseUrl: 'http://test'))..httpClientAdapter = http;

Map<String, Object?> contactJson({
  String id = 'p1',
  String first = 'Luc',
  String last = 'Claes',
  String customer = 'Bêta Industrie SA',
  String customerId = 'c2',
  String customerLanguage = 'fr',
  String? language = 'nl',
  String greeting = 'Dag Luc,',
  List<String> roles = const ['technical'],
  bool portal = false,
}) => {
  'id': id,
  'customer_id': customerId,
  'customer_code': 'C0002',
  'customer_name': customer,
  'first_name': first,
  'last_name': last,
  'full_name': '$first $last',
  'job_title': 'Technician',
  'title': 'mr',
  'address_form': 'informal',
  'language': language,
  'customer_language': customerLanguage,
  'effective_language': language ?? customerLanguage,
  'greeting': greeting,
  'roles': roles,
  'notes': '',
  'active': true,
  'portal_access': portal,
  'portal_scope': 'own',
  'emails': [
    {'email': 'luc.claes@beta.example', 'is_primary': true},
  ],
  'phones': [
    {
      'label': 'mobile',
      'number': '+32 478 00 00 44',
      'normalized': '32478000044',
    },
  ],
  'created_at': '2026-11-05T10:00:00Z',
  'updated_at': '2026-11-05T10:00:00Z',
};

Map<String, Object?> meJson(List<String> permissions) => {
  'user_id': 'u1',
  'email': 'support@example.com',
  'display_name': 'Support Agent',
  'roles': ['support'],
  'permissions': permissions,
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

Map<String, Object?> customerJson() => {
  'id': 'c2',
  'code': 'C0002',
  'name': 'Bêta Industrie SA',
  'street': '',
  'postal_code': '',
  'city': 'Liège',
  'country_code': 'BE',
  'language': 'fr',
  'active': true,
};
