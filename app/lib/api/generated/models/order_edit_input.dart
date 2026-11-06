// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'order_line_edit.dart';

part 'order_edit_input.g.dart';

/// Changes to a draft revision. Lines that are left out are removed; prices and rebates stay as.
/// agreed on the quotation, the totals are recomputed by the server.
@JsonSerializable()
class OrderEditInput {
  const OrderEditInput({
    required this.lines,
    this.customerReference,
    this.notes,
  });
  
  factory OrderEditInput.fromJson(Map<String, Object?> json) => _$OrderEditInputFromJson(json);
  
  @JsonKey(includeIfNull: false,name: 'customer_reference')
  final String? customerReference;
  final List<OrderLineEdit> lines;
  @JsonKey(includeIfNull: false)
  final String? notes;

  Map<String, Object?> toJson() => _$OrderEditInputToJson(this);
}
