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
  productType: json['product_type'] as String,
  unit: json['unit'] as String,
  vatRate: json['vat_rate'] as String,
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'active': instance.active,
  'code': instance.code,
  'description': instance.description,
  'id': instance.id,
  'name': instance.name,
  'product_type': instance.productType,
  'unit': instance.unit,
  'vat_rate': instance.vatRate,
};
