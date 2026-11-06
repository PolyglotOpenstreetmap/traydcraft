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
  barcode: json['barcode'] as String?,
  familyCode: json['family_code'] as String?,
  familyId: json['family_id'] as String?,
  leadTimeDays: (json['lead_time_days'] as num?)?.toInt(),
  reorderMax: json['reorder_max'] as String?,
  reorderMin: json['reorder_min'] as String?,
  standardCost: json['standard_cost'] as String?,
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'active': instance.active,
  'barcode': ?instance.barcode,
  'code': instance.code,
  'description': instance.description,
  'family_code': ?instance.familyCode,
  'family_id': ?instance.familyId,
  'id': instance.id,
  'lead_time_days': ?instance.leadTimeDays,
  'name': instance.name,
  'pricing_type': instance.pricingType,
  'product_type': instance.productType,
  'reorder_max': ?instance.reorderMax,
  'reorder_min': ?instance.reorderMin,
  'standard_cost': ?instance.standardCost,
  'tracking': instance.tracking,
  'unit': instance.unit,
  'vat_rate': instance.vatRate,
};
