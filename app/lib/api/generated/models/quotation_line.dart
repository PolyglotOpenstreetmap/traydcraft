// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'quotation_line.g.dart';

@JsonSerializable()
class QuotationLine {
  const QuotationLine({
    required this.description,
    required this.lineDiscountPercent,
    required this.lineTotal,
    required this.listUnitPrice,
    required this.netUnitPrice,
    required this.position,
    required this.priceConfirmed,
    required this.pricingType,
    required this.productCode,
    required this.quantity,
    required this.rebatePercent,
    required this.rebateSource,
    required this.unit,
    required this.vatRate,
    this.productId,
  });
  
  factory QuotationLine.fromJson(Map<String, Object?> json) => _$QuotationLineFromJson(json);
  
  final String description;
  @JsonKey(name: 'line_discount_percent')
  final String lineDiscountPercent;
  @JsonKey(name: 'line_total')
  final String lineTotal;

  /// Zone list price, or the confirmed price of an indicative product.
  @JsonKey(name: 'list_unit_price')
  final String listUnitPrice;
  @JsonKey(name: 'net_unit_price')
  final String netUnitPrice;
  final int position;

  /// False for an indicative price that still has to be confirmed.
  @JsonKey(name: 'price_confirmed')
  final bool priceConfirmed;

  /// list | net | indicative
  @JsonKey(name: 'pricing_type')
  final String pricingType;
  @JsonKey(name: 'product_code')
  final String productCode;
  @JsonKey(includeIfNull: false,name: 'product_id')
  final String? productId;
  final String quantity;

  /// Customer rebate applied to this line.
  @JsonKey(name: 'rebate_percent')
  final String rebatePercent;

  /// Where the rebate comes from: product | family | general | net
  @JsonKey(name: 'rebate_source')
  final String rebateSource;
  final String unit;
  @JsonKey(name: 'vat_rate')
  final String vatRate;

  Map<String, Object?> toJson() => _$QuotationLineToJson(this);
}
