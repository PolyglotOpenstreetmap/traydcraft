// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/pricing_preview.dart';
import '../models/pricing_preview_input.dart';
import '../models/quotation.dart';
import '../models/quotation_input.dart';
import '../models/quotation_page.dart';

part 'sales_client.g.dart';

@RestApi()
abstract class SalesClient {
  factory SalesClient(Dio dio, {String? baseUrl}) = _SalesClient;

  /// Prices lines for a customer without saving. The app calls this while the user edits,.
  /// so every number on screen comes from the server's pricing engine.
  @POST('/api/v1/pricing/preview')
  Future<PricingPreview> preview({
    @Body() required PricingPreviewInput body,
  });

  /// [q] - Searches number and customer name.
  @GET('/api/v1/quotations')
  Future<QuotationPage> listQuotations({
    @Query('q') String? q,
    @Query('status') String? status,
    @Query('customer_id') String? customerId,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  });

  @POST('/api/v1/quotations')
  Future<Quotation> createQuotation({
    @Body() required QuotationInput body,
  });

  @GET('/api/v1/quotations/{id}')
  Future<Quotation> getQuotation({
    @Path('id') required String id,
  });

  /// Replaces customer, dates, notes and lines of a draft, repricing everything.
  @PUT('/api/v1/quotations/{id}')
  Future<Quotation> updateQuotation({
    @Path('id') required String id,
    @Body() required QuotationInput body,
  });

  @POST('/api/v1/quotations/{id}/accept')
  Future<Quotation> acceptQuotation({
    @Path('id') required String id,
  });

  @GET('/api/v1/quotations/{id}/pdf')
  Future<List<int>> quotationPdf({
    @Path('id') required String id,
  });

  @POST('/api/v1/quotations/{id}/reject')
  Future<Quotation> rejectQuotation({
    @Path('id') required String id,
  });

  /// Creates the next revision as a new draft (same number), repriced at today's prices.
  /// The revised quotation becomes `superseded`.
  @POST('/api/v1/quotations/{id}/revise')
  Future<Quotation> reviseQuotation({
    @Path('id') required String id,
  });

  /// Freezes the quotation. From now on it can only be accepted, rejected or revised.
  @POST('/api/v1/quotations/{id}/send')
  Future<Quotation> sendQuotation({
    @Path('id') required String id,
  });
}
