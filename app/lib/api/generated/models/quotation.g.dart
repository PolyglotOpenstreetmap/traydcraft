// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quotation _$QuotationFromJson(Map<String, dynamic> json) => Quotation(
  companyId: json['company_id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  createdBy: json['created_by'] as String,
  currency: json['currency'] as String,
  customerCity: json['customer_city'] as String,
  customerCountryCode: json['customer_country_code'] as String,
  customerDiscountPercent: json['customer_discount_percent'] as String,
  customerId: json['customer_id'] as String,
  customerLanguage: json['customer_language'] as String,
  customerName: json['customer_name'] as String,
  customerPostalCode: json['customer_postal_code'] as String,
  customerStreet: json['customer_street'] as String,
  id: json['id'] as String,
  lines: (json['lines'] as List<dynamic>)
      .map((e) => QuotationLine.fromJson(e as Map<String, dynamic>))
      .toList(),
  notes: json['notes'] as String,
  number: json['number'] as String,
  priceZoneCode: json['price_zone_code'] as String,
  quoteDate: DateTime.parse(json['quote_date'] as String),
  revision: (json['revision'] as num).toInt(),
  status: QuotationStatus.fromJson(json['status'] as String),
  subtotal: json['subtotal'] as String,
  total: json['total'] as String,
  updatedAt: DateTime.parse(json['updated_at'] as String),
  validUntil: DateTime.parse(json['valid_until'] as String),
  vatGroups: (json['vat_groups'] as List<dynamic>)
      .map((e) => VatGroup.fromJson(e as Map<String, dynamic>))
      .toList(),
  vatTotal: json['vat_total'] as String,
  customerVatNumber: json['customer_vat_number'] as String?,
  opportunityId: json['opportunity_id'] as String?,
  sentAt: json['sent_at'] == null
      ? null
      : DateTime.parse(json['sent_at'] as String),
  supersedesId: json['supersedes_id'] as String?,
);

Map<String, dynamic> _$QuotationToJson(Quotation instance) => <String, dynamic>{
  'company_id': instance.companyId,
  'created_at': instance.createdAt.toIso8601String(),
  'created_by': instance.createdBy,
  'currency': instance.currency,
  'customer_city': instance.customerCity,
  'customer_country_code': instance.customerCountryCode,
  'customer_discount_percent': instance.customerDiscountPercent,
  'customer_id': instance.customerId,
  'customer_language': instance.customerLanguage,
  'customer_name': instance.customerName,
  'customer_postal_code': instance.customerPostalCode,
  'customer_street': instance.customerStreet,
  'customer_vat_number': ?instance.customerVatNumber,
  'id': instance.id,
  'lines': instance.lines,
  'notes': instance.notes,
  'number': instance.number,
  'opportunity_id': ?instance.opportunityId,
  'price_zone_code': instance.priceZoneCode,
  'quote_date': instance.quoteDate.toIso8601String(),
  'revision': instance.revision,
  'sent_at': ?instance.sentAt?.toIso8601String(),
  'status': instance.status,
  'subtotal': instance.subtotal,
  'supersedes_id': ?instance.supersedesId,
  'total': instance.total,
  'updated_at': instance.updatedAt.toIso8601String(),
  'valid_until': instance.validUntil.toIso8601String(),
  'vat_groups': instance.vatGroups,
  'vat_total': instance.vatTotal,
};
