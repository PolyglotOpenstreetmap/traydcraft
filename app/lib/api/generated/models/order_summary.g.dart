// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderSummary _$OrderSummaryFromJson(Map<String, dynamic> json) => OrderSummary(
  currency: json['currency'] as String,
  customerId: json['customer_id'] as String,
  customerName: json['customer_name'] as String,
  customerReference: json['customer_reference'] as String,
  id: json['id'] as String,
  number: json['number'] as String,
  orderDate: DateTime.parse(json['order_date'] as String),
  quotationId: json['quotation_id'] as String,
  quotationNumber: json['quotation_number'] as String,
  quotationRevision: (json['quotation_revision'] as num).toInt(),
  salespersonId: json['salesperson_id'] as String,
  salespersonName: json['salesperson_name'] as String,
  status: json['status'] as String,
  subtotal: json['subtotal'] as String,
  total: json['total'] as String,
);

Map<String, dynamic> _$OrderSummaryToJson(OrderSummary instance) =>
    <String, dynamic>{
      'currency': instance.currency,
      'customer_id': instance.customerId,
      'customer_name': instance.customerName,
      'customer_reference': instance.customerReference,
      'id': instance.id,
      'number': instance.number,
      'order_date': instance.orderDate.toIso8601String(),
      'quotation_id': instance.quotationId,
      'quotation_number': instance.quotationNumber,
      'quotation_revision': instance.quotationRevision,
      'salesperson_id': instance.salespersonId,
      'salesperson_name': instance.salespersonName,
      'status': instance.status,
      'subtotal': instance.subtotal,
      'total': instance.total,
    };
