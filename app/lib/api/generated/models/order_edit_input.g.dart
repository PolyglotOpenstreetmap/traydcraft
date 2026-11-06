// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_edit_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderEditInput _$OrderEditInputFromJson(Map<String, dynamic> json) =>
    OrderEditInput(
      lines: (json['lines'] as List<dynamic>)
          .map((e) => OrderLineEdit.fromJson(e as Map<String, dynamic>))
          .toList(),
      customerReference: json['customer_reference'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$OrderEditInputToJson(OrderEditInput instance) =>
    <String, dynamic>{
      'customer_reference': ?instance.customerReference,
      'lines': instance.lines,
      'notes': ?instance.notes,
    };
