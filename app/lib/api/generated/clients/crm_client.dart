// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/customer.dart';
import '../models/customer_input.dart';
import '../models/customer_page.dart';
import '../models/customer_rebate.dart';
import '../models/opportunity.dart';
import '../models/opportunity_input.dart';
import '../models/opportunity_page.dart';
import '../models/pipeline_stage.dart';
import '../models/rebate_input.dart';
import '../models/stage_input.dart';

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

  @GET('/api/v1/customers/{id}/rebates')
  Future<List<CustomerRebate>> listRebates({
    @Path('id') required String id,
  });

  @POST('/api/v1/customers/{id}/rebates')
  Future<CustomerRebate> createRebate({
    @Path('id') required String id,
    @Body() required RebateInput body,
  });

  @PUT('/api/v1/customers/{id}/rebates/{rebate_id}')
  Future<CustomerRebate> updateRebate({
    @Path('id') required String id,
    @Path('rebate_id') required String rebateId,
    @Body() required RebateInput body,
  });

  /// Removes a rebate. Quotations keep the rebate they were priced with.
  @DELETE('/api/v1/customers/{id}/rebates/{rebate_id}')
  Future<void> deleteRebate({
    @Path('id') required String id,
    @Path('rebate_id') required String rebateId,
  });

  /// [q] - Searches number, title and customer name.
  ///
  /// [open] - Only open (not won or lost) opportunities.
  @GET('/api/v1/opportunities')
  Future<OpportunityPage> listOpportunities({
    @Query('q') String? q,
    @Query('stage') String? stage,
    @Query('customer_id') String? customerId,
    @Query('open') bool? open,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  });

  @POST('/api/v1/opportunities')
  Future<Opportunity> createOpportunity({
    @Body() required OpportunityInput body,
  });

  /// Count, value and probability-weighted value per stage.
  @GET('/api/v1/opportunities/pipeline')
  Future<List<PipelineStage>> pipeline();

  @GET('/api/v1/opportunities/{id}')
  Future<Opportunity> getOpportunity({
    @Path('id') required String id,
  });

  @PUT('/api/v1/opportunities/{id}')
  Future<Opportunity> updateOpportunity({
    @Path('id') required String id,
    @Body() required OpportunityInput body,
  });

  /// Moves an opportunity through the pipeline. `won`/`lost` close it; any other stage reopens it.
  @POST('/api/v1/opportunities/{id}/stage')
  Future<Opportunity> changeStage({
    @Path('id') required String id,
    @Body() required StageInput body,
  });
}
