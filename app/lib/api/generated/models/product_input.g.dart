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
  familyId: json['family_id'] as String?,
  pricingType: json['pricing_type'] as String?,
  productType: json['product_type'] as String?,
  tracking: json['tracking'] as String?,
  unit: json['unit'] as String?,
);

Map<String, dynamic> _$ProductInputToJson(ProductInput instance) =>
    <String, dynamic>{
      'active': ?instance.active,
      'code': instance.code,
      'description': ?instance.description,
      'family_id': ?instance.familyId,
      'name': instance.name,
      'pricing_type': ?instance.pricingType,
      'product_type': ?instance.productType,
      'tracking': ?instance.tracking,
      'unit': ?instance.unit,
      'vat_rate': instance.vatRate,
    };
