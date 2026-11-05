// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'order_summary.g.dart';

@JsonSerializable()
class OrderSummary {
  const OrderSummary({
    required this.currency,
    required this.customerId,
    required this.customerName,
    required this.customerReference,
    required this.id,
    required this.number,
    required this.orderDate,
    required this.quotationId,
    required this.quotationNumber,
    required this.quotationRevision,
    required this.salespersonId,
    required this.salespersonName,
    required this.status,
    required this.subtotal,
    required this.total,
  });
  
  factory OrderSummary.fromJson(Map<String, Object?> json) => _$OrderSummaryFromJson(json);
  
  final String currency;
  @JsonKey(name: 'customer_id')
  final String customerId;
  @JsonKey(name: 'customer_name')
  final String customerName;
  @JsonKey(name: 'customer_reference')
  final String customerReference;
  final String id;
  final String number;
  @JsonKey(name: 'order_date')
  final DateTime orderDate;
  @JsonKey(name: 'quotation_id')
  final String quotationId;
  @JsonKey(name: 'quotation_number')
  final String quotationNumber;
  @JsonKey(name: 'quotation_revision')
  final int quotationRevision;
  @JsonKey(name: 'salesperson_id')
  final String salespersonId;
  @JsonKey(name: 'salesperson_name')
  final String salespersonName;

  /// confirmed | cancelled
  final String status;
  final String subtotal;
  final String total;

  Map<String, Object?> toJson() => _$OrderSummaryToJson(this);
}
