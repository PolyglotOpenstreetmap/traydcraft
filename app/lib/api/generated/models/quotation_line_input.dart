// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'quotation_line_input.g.dart';

@JsonSerializable()
class QuotationLineInput {
  const QuotationLineInput({
    required this.productId,
    required this.quantity,
    this.description,
    this.lineDiscountPercent,
    this.unitPrice,
  });
  
  factory QuotationLineInput.fromJson(Map<String, Object?> json) => _$QuotationLineInputFromJson(json);
  
  /// Overrides the product name on the document.
  @JsonKey(includeIfNull: false)
  final String? description;
  @JsonKey(includeIfNull: false,name: 'line_discount_percent')
  final String? lineDiscountPercent;
  @JsonKey(name: 'product_id')
  final String productId;
  final String quantity;

  /// Confirmed unit price (before rebates) for an indicative product. Indicative lines must be.
  /// confirmed before the quotation can be sent. Not allowed for other products.
  @JsonKey(includeIfNull: false,name: 'unit_price')
  final String? unitPrice;

  Map<String, Object?> toJson() => _$QuotationLineInputToJson(this);
}
