// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'line_availability.g.dart';

@JsonSerializable()
class LineAvailability {
  const LineAvailability({
    required this.available,
    required this.description,
    required this.onHand,
    required this.orderLineId,
    required this.ordered,
    required this.position,
    required this.productCode,
    required this.reserved,
    required this.reservedTotal,
    required this.shortfall,
    required this.state,
    required this.unit,
    this.productId,
  });
  
  factory LineAvailability.fromJson(Map<String, Object?> json) => _$LineAvailabilityFromJson(json);
  
  /// Available to promise: on hand minus everything reserved.
  final String available;
  final String description;

  /// In the warehouses.
  @JsonKey(name: 'on_hand')
  final String onHand;
  @JsonKey(name: 'order_line_id')
  final String orderLineId;

  /// Ordered quantity, in the unit of the line.
  final String ordered;
  final int position;
  @JsonKey(name: 'product_code')
  final String productCode;
  @JsonKey(includeIfNull: false,name: 'product_id')
  final String? productId;

  /// Reserved for this line, in the stock unit.
  final String reserved;

  /// Reserved for all orders.
  @JsonKey(name: 'reserved_total')
  final String reservedTotal;

  /// What neither the reservation nor free stock covers.
  final String shortfall;

  /// reserved | available | partial | short | not_stocked
  final String state;
  final String unit;

  Map<String, Object?> toJson() => _$LineAvailabilityToJson(this);
}
