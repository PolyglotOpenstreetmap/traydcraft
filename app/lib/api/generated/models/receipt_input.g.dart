// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceiptInput _$ReceiptInputFromJson(Map<String, dynamic> json) => ReceiptInput(
  id: json['id'] as String,
  locationId: json['location_id'] as String,
  productId: json['product_id'] as String,
  quantity: json['quantity'] as String,
  expiryDate: json['expiry_date'] == null
      ? null
      : DateTime.parse(json['expiry_date'] as String),
  lotNumber: json['lot_number'] as String?,
  note: json['note'] as String?,
  reason: json['reason'] as String?,
  serialNumber: json['serial_number'] as String?,
  serialUnitId: json['serial_unit_id'] as String?,
  uom: json['uom'] as String?,
);

Map<String, dynamic> _$ReceiptInputToJson(ReceiptInput instance) =>
    <String, dynamic>{
      'expiry_date': ?instance.expiryDate?.toIso8601String(),
      'id': instance.id,
      'location_id': instance.locationId,
      'lot_number': ?instance.lotNumber,
      'note': ?instance.note,
      'product_id': instance.productId,
      'quantity': instance.quantity,
      'reason': ?instance.reason,
      'serial_number': ?instance.serialNumber,
      'serial_unit_id': ?instance.serialUnitId,
      'uom': ?instance.uom,
    };
