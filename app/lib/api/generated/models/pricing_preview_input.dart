// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'quotation_line_input.dart';

part 'pricing_preview_input.g.dart';

@JsonSerializable()
class PricingPreviewInput {
  const PricingPreviewInput({
    required this.customerId,
    required this.lines,
    this.priceDate,
    this.quoteDate,
  });
  
  factory PricingPreviewInput.fromJson(Map<String, Object?> json) => _$PricingPreviewInputFromJson(json);
  
  @JsonKey(name: 'customer_id')
  final String customerId;
  final List<QuotationLineInput> lines;

  /// Price list date; defaults to the quote date.
  @JsonKey(includeIfNull: false,name: 'price_date')
  final DateTime? priceDate;
  @JsonKey(includeIfNull: false,name: 'quote_date')
  final DateTime? quoteDate;

  Map<String, Object?> toJson() => _$PricingPreviewInputToJson(this);
}
