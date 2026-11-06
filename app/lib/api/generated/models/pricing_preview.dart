// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'quotation_line.dart';
import 'vat_group.dart';

part 'pricing_preview.g.dart';

/// Result of pricing lines without saving anything.
@JsonSerializable()
class PricingPreview {
  const PricingPreview({
    required this.customerDiscountPercent,
    required this.lines,
    required this.priceDate,
    required this.priceZoneCode,
    required this.quoteDate,
    required this.subtotal,
    required this.total,
    required this.unconfirmedLines,
    required this.vatGroups,
    required this.vatTotal,
  });
  
  factory PricingPreview.fromJson(Map<String, Object?> json) => _$PricingPreviewFromJson(json);
  
  @JsonKey(name: 'customer_discount_percent')
  final String customerDiscountPercent;
  final List<QuotationLine> lines;
  @JsonKey(name: 'price_date')
  final DateTime priceDate;
  @JsonKey(name: 'price_zone_code')
  final String priceZoneCode;
  @JsonKey(name: 'quote_date')
  final DateTime quoteDate;
  final String subtotal;
  final String total;

  /// Indicative prices still to confirm; the quotation cannot be sent while this is not 0.
  @JsonKey(name: 'unconfirmed_lines')
  final int unconfirmedLines;
  @JsonKey(name: 'vat_groups')
  final List<VatGroup> vatGroups;
  @JsonKey(name: 'vat_total')
  final String vatTotal;

  Map<String, Object?> toJson() => _$PricingPreviewToJson(this);
}
