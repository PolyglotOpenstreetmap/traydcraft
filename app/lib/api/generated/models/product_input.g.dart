// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductInput _$ProductInputFromJson(Map<String, dynamic> json) => ProductInput(
  code: json['code'] as String,
  name: json['name'] as String,
  vatRate: json['vat_rate'] as String,
  active: json['active'] as bool?,
  description: json['description'] as String?,
  productType: json['product_type'] as String?,
  unit: json['unit'] as String?,
);

Map<String, dynamic> _$ProductInputToJson(ProductInput instance) =>
    <String, dynamic>{
      'active': ?instance.active,
      'code': instance.code,
      'description': ?instance.description,
      'name': instance.name,
      'product_type': ?instance.productType,
      'unit': ?instance.unit,
      'vat_rate': instance.vatRate,
    };
