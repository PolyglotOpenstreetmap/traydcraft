// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/announce_repair.dart';
import '../models/login_link_input.dart';
import '../models/message_input.dart';
import '../models/new_ticket.dart';
import '../models/portal_profile.dart';
import '../models/portal_repair.dart';
import '../models/portal_repair_detail.dart';
import '../models/portal_session.dart';
import '../models/portal_ticket.dart';
import '../models/portal_ticket_detail.dart';
import '../models/profile_input.dart';
import '../models/session_input.dart';

part 'portal_client.g.dart';

@RestApi()
abstract class PortalClient {
  factory PortalClient(Dio dio, {String? baseUrl}) = _PortalClient;

  /// Always answers 202, whether or not the address belongs to a portal user, so the endpoint.
  /// cannot be used to find out who is a customer.
  @POST('/api/v1/portal/login-links')
  Future<void> requestLoginLink({
    @Body() required LoginLinkInput body,
  });

  @GET('/api/v1/portal/me')
  Future<PortalProfile> getMe();

  @PUT('/api/v1/portal/me')
  Future<PortalProfile> updateMe({
    @Body() required ProfileInput body,
  });

  @GET('/api/v1/portal/repairs')
  Future<List<PortalRepair>> listPortalRepairs();

  /// Announces a repair that the customer is going to send in. Photos can be added afterwards.
  @POST('/api/v1/portal/repairs')
  Future<PortalRepairDetail> announcePortalRepair({
    @Body() required AnnounceRepair body,
  });

  @GET('/api/v1/portal/repairs/{id}')
  Future<PortalRepairDetail> getPortalRepair({
    @Path('id') required String id,
  });

  /// Adds a photo to a repair: the request body is the image (JPEG, PNG or WebP, at most 12 MB).
  ///
  /// [clientId] - A client-chosen id: sending the same id again returns the first upload.
  @POST('/api/v1/portal/repairs/{id}/photos')
  Future<PortalRepairDetail> uploadPortalRepairPhoto({
    @Path('id') required String id,
    @Body() required String body,
    @Query('caption') String? caption,
    @Query('filename') String? filename,
    @Query('client_id') String? clientId,
  });

  @GET('/api/v1/portal/repairs/{id}/photos/{photo_id}')
  Future<String> getPortalRepairPhoto({
    @Path('id') required String id,
    @Path('photo_id') required String photoId,
  });

  /// Logs out: the session token stops working.
  @DELETE('/api/v1/portal/session')
  Future<void> endSession();

  /// Exchanges a login link for a session. A link works once.
  @POST('/api/v1/portal/sessions')
  Future<PortalSession> createSession({
    @Body() required SessionInput body,
  });

  @GET('/api/v1/portal/tickets')
  Future<List<PortalTicket>> listPortalTickets();

  @POST('/api/v1/portal/tickets')
  Future<PortalTicketDetail> createPortalTicket({
    @Body() required NewTicket body,
  });

  @GET('/api/v1/portal/tickets/{id}')
  Future<PortalTicketDetail> getPortalTicket({
    @Path('id') required String id,
  });

  /// Adds a message to a ticket. A closed ticket is reopened.
  @POST('/api/v1/portal/tickets/{id}/messages')
  Future<PortalTicketDetail> addPortalMessage({
    @Path('id') required String id,
    @Body() required MessageInput body,
  });
}
