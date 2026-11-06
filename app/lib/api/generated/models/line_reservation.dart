// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'allocation.dart';

part 'line_reservation.g.dart';

@JsonSerializable()
class LineReservation {
  const LineReservation({
    required this.allocations,
    required this.orderLineId,
    required this.ordered,
    required this.productCode,
    required this.productId,
    required this.reserved,
  });
  
  factory LineReservation.fromJson(Map<String, Object?> json) => _$LineReservationFromJson(json);
  
  final List<Allocation> allocations;
  @JsonKey(name: 'order_line_id')
  final String orderLineId;

  /// Ordered quantity in the stock unit of the product.
  final String ordered;
  @JsonKey(name: 'product_code')
  final String productCode;
  @JsonKey(name: 'product_id')
  final String productId;
  final String reserved;

  Map<String, Object?> toJson() => _$LineReservationToJson(this);
}
