// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  const Product({
    required this.active,
    required this.code,
    required this.description,
    required this.id,
    required this.name,
    required this.pricingType,
    required this.productType,
    required this.tracking,
    required this.unit,
    required this.vatRate,
    this.familyCode,
    this.familyId,
  });
  
  factory Product.fromJson(Map<String, Object?> json) => _$ProductFromJson(json);
  
  final bool active;
  final String code;
  final String description;
  @JsonKey(includeIfNull: false,name: 'family_code')
  final String? familyCode;
  @JsonKey(includeIfNull: false,name: 'family_id')
  final String? familyId;
  final String id;
  final String name;

  /// list (rebates apply) | net (fixed net price, never discounted) |.
  /// indicative (price must be confirmed on each quotation).
  @JsonKey(name: 'pricing_type')
  final String pricingType;

  /// purchased | manufactured | configurable | service
  @JsonKey(name: 'product_type')
  final String productType;

  /// none | serial — serial-tracked products get an individual serial number per unit.
  final String tracking;
  final String unit;
  @JsonKey(name: 'vat_rate')
  final String vatRate;

  Map<String, Object?> toJson() => _$ProductToJson(this);
}
