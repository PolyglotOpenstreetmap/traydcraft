// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'ticket.g.dart';

@JsonSerializable()
class Ticket {
  const Ticket({
    required this.articleCount,
    required this.category,
    required this.contactEmail,
    required this.contactName,
    required this.createdAt,
    required this.id,
    required this.internal,
    required this.language,
    required this.number,
    required this.priority,
    required this.status,
    required this.subject,
    required this.updatedAt,
    this.closedAt,
    this.customerId,
    this.customerName,
    this.firstResponseAt,
    this.opportunityId,
    this.opportunityNumber,
    this.orderId,
    this.orderNumber,
    this.ownerName,
    this.ownerUserId,
    this.quotationId,
    this.quotationNumber,
    this.quotationRevision,
    this.quotationStatus,
    this.suggestedCategory,
  });
  
  factory Ticket.fromJson(Map<String, Object?> json) => _$TicketFromJson(json);
  
  @JsonKey(name: 'article_count')
  final int articleCount;

  /// question | lead | quote_change | order_confirmation | production_question | service | complaint | other
  final String category;
  @JsonKey(includeIfNull: false,name: 'closed_at')
  final DateTime? closedAt;
  @JsonKey(name: 'contact_email')
  final String contactEmail;
  @JsonKey(name: 'contact_name')
  final String contactName;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(includeIfNull: false,name: 'customer_id')
  final String? customerId;
  @JsonKey(includeIfNull: false,name: 'customer_name')
  final String? customerName;
  @JsonKey(includeIfNull: false,name: 'first_response_at')
  final DateTime? firstResponseAt;
  final String id;
  final bool internal;

  /// nl | fr | en | de | es — the language to answer in.
  final String language;
  final String number;
  @JsonKey(includeIfNull: false,name: 'opportunity_id')
  final String? opportunityId;
  @JsonKey(includeIfNull: false,name: 'opportunity_number')
  final String? opportunityNumber;
  @JsonKey(includeIfNull: false,name: 'order_id')
  final String? orderId;
  @JsonKey(includeIfNull: false,name: 'order_number')
  final String? orderNumber;
  @JsonKey(includeIfNull: false,name: 'owner_name')
  final String? ownerName;
  @JsonKey(includeIfNull: false,name: 'owner_user_id')
  final String? ownerUserId;

  /// low | normal | high | urgent
  final String priority;
  @JsonKey(includeIfNull: false,name: 'quotation_id')
  final String? quotationId;
  @JsonKey(includeIfNull: false,name: 'quotation_number')
  final String? quotationNumber;
  @JsonKey(includeIfNull: false,name: 'quotation_revision')
  final int? quotationRevision;
  @JsonKey(includeIfNull: false,name: 'quotation_status')
  final String? quotationStatus;

  /// new | open | pending_customer | pending_internal | closed
  final String status;
  final String subject;

  /// What the system guessed from the last incoming e-mail.
  @JsonKey(includeIfNull: false,name: 'suggested_category')
  final String? suggestedCategory;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Map<String, Object?> toJson() => _$TicketToJson(this);
}
