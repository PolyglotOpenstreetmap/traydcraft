// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'order_line.g.dart';

@JsonSerializable()
class OrderLine {
  const OrderLine({
    required this.description,
    required this.lineDiscountPercent,
    required this.lineTotal,
    required this.listUnitPrice,
    required this.netUnitPrice,
    required this.position,
    required this.pricingType,
    required this.productCode,
    required this.quantity,
    required this.rebatePercent,
    required this.unit,
    required this.vatRate,
    this.productId,
  });
  
  factory OrderLine.fromJson(Map<String, Object?> json) => _$OrderLineFromJson(json);
  
  final String description;
  @JsonKey(name: 'line_discount_percent')
  final String lineDiscountPercent;
  @JsonKey(name: 'line_total')
  final String lineTotal;
  @JsonKey(name: 'list_unit_price')
  final String listUnitPrice;
  @JsonKey(name: 'net_unit_price')
  final String netUnitPrice;
  final int position;

  /// list | net | indicative
  @JsonKey(name: 'pricing_type')
  final String pricingType;
  @JsonKey(name: 'product_code')
  final String productCode;
  @JsonKey(includeIfNull: false,name: 'product_id')
  final String? productId;
  final String quantity;
  @JsonKey(name: 'rebate_percent')
  final String rebatePercent;
  final String unit;
  @JsonKey(name: 'vat_rate')
  final String vatRate;

  Map<String, Object?> toJson() => _$OrderLineToJson(this);
}
