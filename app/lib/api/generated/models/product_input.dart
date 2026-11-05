// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'product_input.g.dart';

@JsonSerializable()
class ProductInput {
  const ProductInput({
    required this.code,
    required this.name,
    required this.vatRate,
    this.active,
    this.description,
    this.familyId,
    this.pricingType,
    this.productType,
    this.tracking,
    this.unit,
  });
  
  factory ProductInput.fromJson(Map<String, Object?> json) => _$ProductInputFromJson(json);
  
  @JsonKey(includeIfNull: false)
  final bool? active;
  final String code;
  @JsonKey(includeIfNull: false)
  final String? description;
  @JsonKey(includeIfNull: false,name: 'family_id')
  final String? familyId;
  final String name;

  /// list | net | indicative
  @JsonKey(includeIfNull: false,name: 'pricing_type')
  final String? pricingType;
  @JsonKey(includeIfNull: false,name: 'product_type')
  final String? productType;

  /// none | serial
  @JsonKey(includeIfNull: false)
  final String? tracking;
  @JsonKey(includeIfNull: false)
  final String? unit;
  @JsonKey(name: 'vat_rate')
  final String vatRate;

  Map<String, Object?> toJson() => _$ProductInputToJson(this);
}
