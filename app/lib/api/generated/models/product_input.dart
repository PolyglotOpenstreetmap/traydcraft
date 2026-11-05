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
    this.productType,
    this.unit,
  });
  
  factory ProductInput.fromJson(Map<String, Object?> json) => _$ProductInputFromJson(json);
  
  @JsonKey(includeIfNull: false)
  final bool? active;
  final String code;
  @JsonKey(includeIfNull: false)
  final String? description;
  final String name;
  @JsonKey(includeIfNull: false,name: 'product_type')
  final String? productType;
  @JsonKey(includeIfNull: false)
  final String? unit;
  @JsonKey(name: 'vat_rate')
  final String vatRate;

  Map<String, Object?> toJson() => _$ProductInputToJson(this);
}
