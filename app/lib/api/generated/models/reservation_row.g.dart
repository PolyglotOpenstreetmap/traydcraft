// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationRow _$ReservationRowFromJson(Map<String, dynamic> json) =>
    ReservationRow(
      createdAt: DateTime.parse(json['created_at'] as String),
      customerName: json['customer_name'] as String,
      id: json['id'] as String,
      location: json['location'] as String,
      orderId: json['order_id'] as String,
      orderLineId: json['order_line_id'] as String,
      orderNumber: json['order_number'] as String,
      position: (json['position'] as num).toInt(),
      productCode: json['product_code'] as String,
      productId: json['product_id'] as String,
      quantity: json['quantity'] as String,
      lotNumber: json['lot_number'] as String?,
    );

Map<String, dynamic> _$ReservationRowToJson(ReservationRow instance) =>
    <String, dynamic>{
      'created_at': instance.createdAt.toIso8601String(),
      'customer_name': instance.customerName,
      'id': instance.id,
      'location': instance.location,
      'lot_number': ?instance.lotNumber,
      'order_id': instance.orderId,
      'order_line_id': instance.orderLineId,
      'order_number': instance.orderNumber,
      'position': instance.position,
      'product_code': instance.productCode,
      'product_id': instance.productId,
      'quantity': instance.quantity,
    };
