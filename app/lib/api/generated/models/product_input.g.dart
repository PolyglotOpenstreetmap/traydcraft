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
  barcode: json['barcode'] as String?,
  description: json['description'] as String?,
  familyId: json['family_id'] as String?,
  leadTimeDays: (json['lead_time_days'] as num?)?.toInt(),
  pricingType: json['pricing_type'] as String?,
  productType: json['product_type'] as String?,
  reorderMax: json['reorder_max'] as String?,
  reorderMin: json['reorder_min'] as String?,
  standardCost: json['standard_cost'] as String?,
  tracking: json['tracking'] as String?,
  unit: json['unit'] as String?,
);

Map<String, dynamic> _$ProductInputToJson(ProductInput instance) =>
    <String, dynamic>{
      'active': ?instance.active,
      'barcode': ?instance.barcode,
      'code': instance.code,
      'description': ?instance.description,
      'family_id': ?instance.familyId,
      'lead_time_days': ?instance.leadTimeDays,
      'name': instance.name,
      'pricing_type': ?instance.pricingType,
      'product_type': ?instance.productType,
      'reorder_max': ?instance.reorderMax,
      'reorder_min': ?instance.reorderMin,
      'standard_cost': ?instance.standardCost,
      'tracking': ?instance.tracking,
      'unit': ?instance.unit,
      'vat_rate': instance.vatRate,
    };
