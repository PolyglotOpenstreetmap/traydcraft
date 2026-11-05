// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/bulk_price_change_input.dart';
import '../models/bulk_price_preview.dart';
import '../models/price_zone.dart';
import '../models/product.dart';
import '../models/product_family.dart';
import '../models/product_family_input.dart';
import '../models/product_input.dart';
import '../models/product_page.dart';
import '../models/zone_price_entry.dart';
import '../models/zone_price_input.dart';

part 'products_client.g.dart';

@RestApi()
abstract class ProductsClient {
  factory ProductsClient(Dio dio, {String? baseUrl}) = _ProductsClient;

  @GET('/api/v1/price-zones')
  Future<List<PriceZone>> listPriceZones();

  /// Applies a bulk price change: one new dated price per product and zone.
  /// Refused if any product already has a price starting on the same date.
  @POST('/api/v1/prices/bulk/apply')
  Future<BulkPricePreview> applyBulk({
    @Body() required BulkPriceChangeInput body,
  });

  /// Shows what a bulk price change would do, without changing anything.
  @POST('/api/v1/prices/bulk/preview')
  Future<BulkPricePreview> previewBulk({
    @Body() required BulkPriceChangeInput body,
  });

  @GET('/api/v1/product-families')
  Future<List<ProductFamily>> listFamilies();

  @POST('/api/v1/product-families')
  Future<ProductFamily> createFamily({
    @Body() required ProductFamilyInput body,
  });

  @PUT('/api/v1/product-families/{id}')
  Future<ProductFamily> updateFamily({
    @Path('id') required String id,
    @Body() required ProductFamilyInput body,
  });

  /// [q] - Searches code and name.
  @GET('/api/v1/products')
  Future<ProductPage> listProducts({
    @Query('q') String? q,
    @Query('active') bool? active,
    @Query('family_id') String? familyId,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  });

  @POST('/api/v1/products')
  Future<Product> createProduct({
    @Body() required ProductInput body,
  });

  @GET('/api/v1/products/{id}')
  Future<Product> getProduct({
    @Path('id') required String id,
  });

  @PUT('/api/v1/products/{id}')
  Future<Product> updateProduct({
    @Path('id') required String id,
    @Body() required ProductInput body,
  });

  /// Full price history of a product in the active company, newest first per zone.
  @GET('/api/v1/products/{id}/prices')
  Future<List<ZonePriceEntry>> listProductPrices({
    @Path('id') required String id,
  });

  /// Adds a price for a zone from a date. Prices are never edited: a new entry supersedes older ones.
  @POST('/api/v1/products/{id}/prices')
  Future<ZonePriceEntry> addProductPrice({
    @Path('id') required String id,
    @Body() required ZonePriceInput body,
  });
}
