// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'quotation_line_input.dart';

part 'quotation_input.g.dart';

@JsonSerializable()
class QuotationInput {
  const QuotationInput({
    required this.customerId,
    required this.lines,
    this.notes,
    this.opportunityId,
    this.quoteDate,
    this.validDays,
  });
  
  factory QuotationInput.fromJson(Map<String, Object?> json) => _$QuotationInputFromJson(json);
  
  @JsonKey(name: 'customer_id')
  final String customerId;
  final List<QuotationLineInput> lines;
  @JsonKey(includeIfNull: false)
  final String? notes;

  /// Links the quotation to an open opportunity of the same customer.
  @JsonKey(includeIfNull: false,name: 'opportunity_id')
  final String? opportunityId;

  /// Defaults to today. Prices valid on this date are used.
  @JsonKey(includeIfNull: false,name: 'quote_date')
  final DateTime? quoteDate;

  /// Defaults to 30 days.
  @JsonKey(includeIfNull: false,name: 'valid_days')
  final int? validDays;

  Map<String, Object?> toJson() => _$QuotationInputToJson(this);
}
