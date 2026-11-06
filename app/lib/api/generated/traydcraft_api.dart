// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';

import 'clients/engineering_client.dart';
import 'clients/crm_client.dart';
import 'clients/helpdesk_client.dart';
import 'clients/repairs_client.dart';
import 'clients/field_client.dart';
import 'clients/kb_client.dart';
import 'clients/core_client.dart';
import 'clients/sales_client.dart';
import 'clients/portal_client.dart';
import 'clients/products_client.dart';

/// traydcraft API `v0.1.0`.
///
/// Business platform API (CRM, products, pricing, sales, engineering, helpdesk, customer portal).
class TraydcraftApi {
  TraydcraftApi(
    Dio dio, {
    String? baseUrl,
  })  : _dio = dio,
        _baseUrl = baseUrl;

  final Dio _dio;
  final String? _baseUrl;

  static String get version => '0.1.0';

  EngineeringClient? _engineering;
  CrmClient? _crm;
  HelpdeskClient? _helpdesk;
  RepairsClient? _repairs;
  FieldClient? _field;
  KbClient? _kb;
  CoreClient? _core;
  SalesClient? _sales;
  PortalClient? _portal;
  ProductsClient? _products;

  EngineeringClient get engineering => _engineering ??= EngineeringClient(_dio, baseUrl: _baseUrl);

  CrmClient get crm => _crm ??= CrmClient(_dio, baseUrl: _baseUrl);

  HelpdeskClient get helpdesk => _helpdesk ??= HelpdeskClient(_dio, baseUrl: _baseUrl);

  RepairsClient get repairs => _repairs ??= RepairsClient(_dio, baseUrl: _baseUrl);

  FieldClient get field => _field ??= FieldClient(_dio, baseUrl: _baseUrl);

  KbClient get kb => _kb ??= KbClient(_dio, baseUrl: _baseUrl);

  CoreClient get core => _core ??= CoreClient(_dio, baseUrl: _baseUrl);

  SalesClient get sales => _sales ??= SalesClient(_dio, baseUrl: _baseUrl);

  PortalClient get portal => _portal ??= PortalClient(_dio, baseUrl: _baseUrl);

  ProductsClient get products => _products ??= ProductsClient(_dio, baseUrl: _baseUrl);
}
