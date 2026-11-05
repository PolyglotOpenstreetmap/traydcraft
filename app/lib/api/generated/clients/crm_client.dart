// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/customer.dart';
import '../models/customer_input.dart';
import '../models/customer_page.dart';

part 'crm_client.g.dart';

@RestApi()
abstract class CrmClient {
  factory CrmClient(Dio dio, {String? baseUrl}) = _CrmClient;

  /// [q] - Searches code, name, VAT number and city.
  @GET('/api/v1/customers')
  Future<CustomerPage> listCustomers({
    @Query('q') String? q,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  });

  @POST('/api/v1/customers')
  Future<Customer> createCustomer({
    @Body() required CustomerInput body,
  });

  @GET('/api/v1/customers/{id}')
  Future<Customer> getCustomer({
    @Path('id') required String id,
  });

  @PUT('/api/v1/customers/{id}')
  Future<Customer> updateCustomer({
    @Path('id') required String id,
    @Body() required CustomerInput body,
  });
}
