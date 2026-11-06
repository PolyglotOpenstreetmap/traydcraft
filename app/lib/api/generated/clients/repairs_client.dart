// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/department.dart';
import '../models/department_input.dart';
import '../models/new_repair_input.dart';
import '../models/repair.dart';
import '../models/repair_detail.dart';
import '../models/repair_input.dart';
import '../models/repair_note_input.dart';
import '../models/repair_page.dart';
import '../models/route_input.dart';
import '../models/status_input.dart';

part 'repairs_client.g.dart';

@RestApi()
abstract class RepairsClient {
  factory RepairsClient(Dio dio, {String? baseUrl}) = _RepairsClient;

  @GET('/api/v1/departments')
  Future<List<Department>> listDepartments();

  @POST('/api/v1/departments')
  Future<Department> createDepartment({
    @Body() required DepartmentInput body,
  });

  @PUT('/api/v1/departments/{id}')
  Future<Department> updateDepartment({
    @Path('id') required String id,
    @Body() required DepartmentInput body,
  });

  /// [q] - Searches number, customer, serial number, product and fault.
  ///
  /// [status] - A status, or `open` for everything not yet shipped or cancelled.
  ///
  /// [department] - A department id, or `none` for repairs not routed yet.
  ///
  /// [assigned] - `me` for repairs assigned to me, or a user id.
  @GET('/api/v1/repairs')
  Future<RepairPage> listRepairs({
    @Query('q') String? q,
    @Query('status') String? status,
    @Query('department') String? department,
    @Query('assigned') String? assigned,
    @Query('customer_id') String? customerId,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  });

  /// Registers a repair. Give a `ticket_id` to create it from the ticket where it was announced.
  @POST('/api/v1/repairs')
  Future<RepairDetail> createRepair({
    @Body() required NewRepairInput body,
  });

  @GET('/api/v1/repairs/{id}')
  Future<RepairDetail> getRepair({
    @Path('id') required String id,
  });

  /// Changes the descriptive fields of a repair (not its status or department).
  @PUT('/api/v1/repairs/{id}')
  Future<RepairDetail> updateRepair({
    @Path('id') required String id,
    @Body() required RepairInput body,
  });

  /// An internal note on the repair (diagnosis, parts used, test results). The customer never sees it.
  @POST('/api/v1/repairs/{id}/notes')
  Future<RepairDetail> addRepairNote({
    @Path('id') required String id,
    @Body() required RepairNoteInput body,
  });

  /// Adds a photo: the request body is the image itself (JPEG, PNG or WebP, at most 12 MB).
  ///
  /// [filename] - The original file name.
  ///
  /// [clientId] - A client-chosen id: uploading the same id again returns the first upload (safe retries).
  @POST('/api/v1/repairs/{id}/photos')
  Future<RepairDetail> uploadRepairPhoto({
    @Path('id') required String id,
    @Body() required String body,
    @Query('caption') String? caption,
    @Query('filename') String? filename,
    @Query('client_id') String? clientId,
  });

  /// The image itself.
  @GET('/api/v1/repairs/{id}/photos/{photo_id}')
  Future<String> getRepairPhoto({
    @Path('id') required String id,
    @Path('photo_id') required String photoId,
  });

  /// Routes a repair to a department (or on to another one). It waits there as `routed`.
  @POST('/api/v1/repairs/{id}/route')
  Future<RepairDetail> routeRepair({
    @Path('id') required String id,
    @Body() required RouteInput body,
  });

  /// Moves a repair along its workflow (everything except routing, see `/route`).
  @POST('/api/v1/repairs/{id}/status')
  Future<RepairDetail> setRepairStatus({
    @Path('id') required String id,
    @Body() required StatusInput body,
  });

  /// The repairs registered for a ticket (the ticket may announce several).
  @GET('/api/v1/tickets/{id}/repairs')
  Future<List<Repair>> listTicketRepairs({
    @Path('id') required String id,
  });
}
