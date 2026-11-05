// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/convert_ticket_input.dart';
import '../models/inbound_result.dart';
import '../models/lead_input.dart';
import '../models/new_ticket_input.dart';
import '../models/note_input.dart';
import '../models/prepared_answer.dart';
import '../models/prepared_answer_input.dart';
import '../models/production_question_input.dart';
import '../models/rendered_answer.dart';
import '../models/reply_input.dart';
import '../models/ticket_detail.dart';
import '../models/ticket_input.dart';
import '../models/ticket_page.dart';

part 'helpdesk_client.g.dart';

@RestApi()
abstract class HelpdeskClient {
  factory HelpdeskClient(Dio dio, {String? baseUrl}) = _HelpdeskClient;

  /// Imports a raw e-mail (RFC 5322, e.g. a saved .eml file) as if it had arrived in the mailbox.
  @POST('/api/v1/helpdesk/inbound')
  Future<InboundResult> inbound({
    @Body() required String body,
  });

  /// [q] - Searches code, name and texts.
  @GET('/api/v1/prepared-answers')
  Future<List<PreparedAnswer>> listAnswers({
    @Query('q') String? q,
    @Query('active') bool? active,
  });

  @POST('/api/v1/prepared-answers')
  Future<PreparedAnswer> createAnswer({
    @Body() required PreparedAnswerInput body,
  });

  /// Placeholders that can be used in prepared answers, e.g. `{{quotation.number}}`.
  @GET('/api/v1/prepared-answers/placeholders')
  Future<List<String>> placeholders();

  @PUT('/api/v1/prepared-answers/{id}')
  Future<PreparedAnswer> updateAnswer({
    @Path('id') required String id,
    @Body() required PreparedAnswerInput body,
  });

  /// [q] - Searches number, subject, contact and customer.
  ///
  /// [status] - A status, or `active` for everything not closed.
  ///
  /// [owner] - `me` for my tickets, `none` for unassigned, or a user id.
  @GET('/api/v1/tickets')
  Future<TicketPage> listTickets({
    @Query('q') String? q,
    @Query('status') String? status,
    @Query('owner') String? owner,
    @Query('customer_id') String? customerId,
    @Query('category') String? category,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  });

  @POST('/api/v1/tickets')
  Future<TicketDetail> createTicket({
    @Body() required NewTicketInput body,
  });

  /// Production asks a question about an order. It becomes an internal ticket for the salesperson,.
  /// in the customer's language, so they can ask the customer and report back in a note.
  @POST('/api/v1/tickets/production-question')
  Future<TicketDetail> productionQuestion({
    @Body() required ProductionQuestionInput body,
  });

  @GET('/api/v1/tickets/{id}')
  Future<TicketDetail> getTicket({
    @Path('id') required String id,
  });

  @PUT('/api/v1/tickets/{id}')
  Future<TicketDetail> updateTicket({
    @Path('id') required String id,
    @Body() required TicketInput body,
  });

  /// The customer confirmed the linked quotation: convert it into a sales order.
  /// If the customer asked for changes, revise the quotation first and link the new revision.
  @POST('/api/v1/tickets/{id}/convert')
  Future<TicketDetail> convert({
    @Path('id') required String id,
    @Body() required ConvertTicketInput body,
  });

  /// Turns the ticket into a sales lead: creates an opportunity for its customer and links it.
  @POST('/api/v1/tickets/{id}/lead')
  Future<TicketDetail> createLead({
    @Path('id') required String id,
    @Body() required LeadInput body,
  });

  /// Adds an internal note: never sent to the customer.
  @POST('/api/v1/tickets/{id}/notes')
  Future<TicketDetail> addNote({
    @Path('id') required String id,
    @Body() required NoteInput body,
  });

  /// Fills in a prepared answer for a ticket, in the ticket's language. Nothing is sent.
  @POST('/api/v1/tickets/{id}/prepared-answers/{answer_id}/render')
  Future<RenderedAnswer> renderAnswer({
    @Path('id') required String id,
    @Path('answer_id') required String answerId,
  });

  /// Queues an e-mail to the customer. The worker sends it; delivery status shows on the article.
  @POST('/api/v1/tickets/{id}/replies')
  Future<TicketDetail> reply({
    @Path('id') required String id,
    @Body() required ReplyInput body,
  });
}
