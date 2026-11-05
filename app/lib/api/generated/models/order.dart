// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'order_line.dart';
import 'order_summary.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  const Order({
    required this.createdAt,
    required this.lines,
    required this.notes,
    required this.order,
    required this.vatTotal,
  });
  
  factory Order.fromJson(Map<String, Object?> json) => _$OrderFromJson(json);
  
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  final List<OrderLine> lines;
  final String notes;
  final OrderSummary order;
  @JsonKey(name: 'vat_total')
  final String vatTotal;

  Map<String, Object?> toJson() => _$OrderToJson(this);
}
