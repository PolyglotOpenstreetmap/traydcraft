// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'reservation_row.g.dart';

@JsonSerializable()
class ReservationRow {
  const ReservationRow({
    required this.createdAt,
    required this.customerName,
    required this.id,
    required this.location,
    required this.orderId,
    required this.orderLineId,
    required this.orderNumber,
    required this.position,
    required this.productCode,
    required this.productId,
    required this.quantity,
    this.lotNumber,
  });
  
  factory ReservationRow.fromJson(Map<String, Object?> json) => _$ReservationRowFromJson(json);
  
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'customer_name')
  final String customerName;
  final String id;
  final String location;
  @JsonKey(includeIfNull: false,name: 'lot_number')
  final String? lotNumber;
  @JsonKey(name: 'order_id')
  final String orderId;
  @JsonKey(name: 'order_line_id')
  final String orderLineId;
  @JsonKey(name: 'order_number')
  final String orderNumber;
  final int position;
  @JsonKey(name: 'product_code')
  final String productCode;
  @JsonKey(name: 'product_id')
  final String productId;
  final String quantity;

  Map<String, Object?> toJson() => _$ReservationRowToJson(this);
}
