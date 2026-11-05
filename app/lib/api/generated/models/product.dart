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
    required this.productType,
    required this.unit,
    required this.vatRate,
  });
  
  factory Product.fromJson(Map<String, Object?> json) => _$ProductFromJson(json);
  
  final bool active;
  final String code;
  final String description;
  final String id;
  final String name;

  /// purchased | manufactured | configurable | service
  @JsonKey(name: 'product_type')
  final String productType;
  final String unit;
  @JsonKey(name: 'vat_rate')
  final String vatRate;

  Map<String, Object?> toJson() => _$ProductToJson(this);
}
