// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ticket _$TicketFromJson(Map<String, dynamic> json) => Ticket(
  articleCount: (json['article_count'] as num).toInt(),
  category: json['category'] as String,
  contactEmail: json['contact_email'] as String,
  contactName: json['contact_name'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  id: json['id'] as String,
  internal: json['internal'] as bool,
  language: json['language'] as String,
  number: json['number'] as String,
  priority: json['priority'] as String,
  status: json['status'] as String,
  subject: json['subject'] as String,
  updatedAt: DateTime.parse(json['updated_at'] as String),
  closedAt: json['closed_at'] == null
      ? null
      : DateTime.parse(json['closed_at'] as String),
  contactId: json['contact_id'] as String?,
  customerId: json['customer_id'] as String?,
  customerName: json['customer_name'] as String?,
  firstResponseAt: json['first_response_at'] == null
      ? null
      : DateTime.parse(json['first_response_at'] as String),
  opportunityId: json['opportunity_id'] as String?,
  opportunityNumber: json['opportunity_number'] as String?,
  orderId: json['order_id'] as String?,
  orderNumber: json['order_number'] as String?,
  ownerName: json['owner_name'] as String?,
  ownerUserId: json['owner_user_id'] as String?,
  quotationId: json['quotation_id'] as String?,
  quotationNumber: json['quotation_number'] as String?,
  quotationRevision: (json['quotation_revision'] as num?)?.toInt(),
  quotationStatus: json['quotation_status'] as String?,
  suggestedCategory: json['suggested_category'] as String?,
);

Map<String, dynamic> _$TicketToJson(Ticket instance) => <String, dynamic>{
  'article_count': instance.articleCount,
  'category': instance.category,
  'closed_at': ?instance.closedAt?.toIso8601String(),
  'contact_email': instance.contactEmail,
  'contact_id': ?instance.contactId,
  'contact_name': instance.contactName,
  'created_at': instance.createdAt.toIso8601String(),
  'customer_id': ?instance.customerId,
  'customer_name': ?instance.customerName,
  'first_response_at': ?instance.firstResponseAt?.toIso8601String(),
  'id': instance.id,
  'internal': instance.internal,
  'language': instance.language,
  'number': instance.number,
  'opportunity_id': ?instance.opportunityId,
  'opportunity_number': ?instance.opportunityNumber,
  'order_id': ?instance.orderId,
  'order_number': ?instance.orderNumber,
  'owner_name': ?instance.ownerName,
  'owner_user_id': ?instance.ownerUserId,
  'priority': instance.priority,
  'quotation_id': ?instance.quotationId,
  'quotation_number': ?instance.quotationNumber,
  'quotation_revision': ?instance.quotationRevision,
  'quotation_status': ?instance.quotationStatus,
  'status': instance.status,
  'subject': instance.subject,
  'suggested_category': ?instance.suggestedCategory,
  'updated_at': instance.updatedAt.toIso8601String(),
};
