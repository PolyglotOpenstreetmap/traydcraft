// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
  createdAt: DateTime.parse(json['created_at'] as String),
  lines: (json['lines'] as List<dynamic>)
      .map((e) => OrderLine.fromJson(e as Map<String, dynamic>))
      .toList(),
  notes: json['notes'] as String,
  order: OrderSummary.fromJson(json['order'] as Map<String, dynamic>),
  vatTotal: json['vat_total'] as String,
);

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
  'created_at': instance.createdAt.toIso8601String(),
  'lines': instance.lines,
  'notes': instance.notes,
  'order': instance.order,
  'vat_total': instance.vatTotal,
};
