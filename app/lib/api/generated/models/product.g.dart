// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  active: json['active'] as bool,
  code: json['code'] as String,
  description: json['description'] as String,
  id: json['id'] as String,
  name: json['name'] as String,
  pricingType: json['pricing_type'] as String,
  productType: json['product_type'] as String,
  tracking: json['tracking'] as String,
  unit: json['unit'] as String,
  vatRate: json['vat_rate'] as String,
  familyCode: json['family_code'] as String?,
  familyId: json['family_id'] as String?,
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'active': instance.active,
  'code': instance.code,
  'description': instance.description,
  'family_code': ?instance.familyCode,
  'family_id': ?instance.familyId,
  'id': instance.id,
  'name': instance.name,
  'pricing_type': instance.pricingType,
  'product_type': instance.productType,
  'tracking': instance.tracking,
  'unit': instance.unit,
  'vat_rate': instance.vatRate,
};
