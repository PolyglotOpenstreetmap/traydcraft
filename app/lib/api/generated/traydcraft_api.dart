// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';

import 'clients/engineering_client.dart';
import 'clients/crm_client.dart';
import 'clients/core_client.dart';
import 'clients/products_client.dart';
import 'clients/sales_client.dart';

/// traydcraft API `v0.1.0`.
///
/// Business platform API (CRM, products, pricing, sales, engineering).
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
  CoreClient? _core;
  ProductsClient? _products;
  SalesClient? _sales;

  EngineeringClient get engineering => _engineering ??= EngineeringClient(_dio, baseUrl: _baseUrl);

  CrmClient get crm => _crm ??= CrmClient(_dio, baseUrl: _baseUrl);

  CoreClient get core => _core ??= CoreClient(_dio, baseUrl: _baseUrl);

  ProductsClient get products => _products ??= ProductsClient(_dio, baseUrl: _baseUrl);

  SalesClient get sales => _sales ??= SalesClient(_dio, baseUrl: _baseUrl);
}
