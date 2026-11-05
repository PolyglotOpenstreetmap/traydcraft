// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'quotation_line.dart';
import 'quotation_status.dart';
import 'vat_group.dart';

part 'quotation.g.dart';

/// A quotation with its lines (flat JSON: header fields, `lines`, `vat_groups`).
@JsonSerializable()
class Quotation {
  const Quotation({
    required this.companyId,
    required this.createdAt,
    required this.createdBy,
    required this.currency,
    required this.customerCity,
    required this.customerCountryCode,
    required this.customerDiscountPercent,
    required this.customerId,
    required this.customerLanguage,
    required this.customerName,
    required this.customerPostalCode,
    required this.customerStreet,
    required this.id,
    required this.lines,
    required this.notes,
    required this.number,
    required this.priceZoneCode,
    required this.quoteDate,
    required this.revision,
    required this.status,
    required this.subtotal,
    required this.total,
    required this.updatedAt,
    required this.validUntil,
    required this.vatGroups,
    required this.vatTotal,
    this.customerVatNumber,
    this.sentAt,
    this.supersedesId,
  });
  
  factory Quotation.fromJson(Map<String, Object?> json) => _$QuotationFromJson(json);
  
  @JsonKey(name: 'company_id')
  final String companyId;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'created_by')
  final String createdBy;
  final String currency;
  @JsonKey(name: 'customer_city')
  final String customerCity;
  @JsonKey(name: 'customer_country_code')
  final String customerCountryCode;
  @JsonKey(name: 'customer_discount_percent')
  final String customerDiscountPercent;
  @JsonKey(name: 'customer_id')
  final String customerId;
  @JsonKey(name: 'customer_language')
  final String customerLanguage;
  @JsonKey(name: 'customer_name')
  final String customerName;
  @JsonKey(name: 'customer_postal_code')
  final String customerPostalCode;
  @JsonKey(name: 'customer_street')
  final String customerStreet;
  @JsonKey(includeIfNull: false,name: 'customer_vat_number')
  final String? customerVatNumber;
  final String id;
  final List<QuotationLine> lines;
  final String notes;
  final String number;
  @JsonKey(name: 'price_zone_code')
  final String priceZoneCode;
  @JsonKey(name: 'quote_date')
  final DateTime quoteDate;
  final int revision;
  @JsonKey(includeIfNull: false,name: 'sent_at')
  final DateTime? sentAt;
  final QuotationStatus status;
  final String subtotal;
  @JsonKey(includeIfNull: false,name: 'supersedes_id')
  final String? supersedesId;
  final String total;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'valid_until')
  final DateTime validUntil;
  @JsonKey(name: 'vat_groups')
  final List<VatGroup> vatGroups;
  @JsonKey(name: 'vat_total')
  final String vatTotal;

  Map<String, Object?> toJson() => _$QuotationToJson(this);
}
