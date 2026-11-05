// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pricing_preview_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PricingPreviewInput _$PricingPreviewInputFromJson(Map<String, dynamic> json) =>
    PricingPreviewInput(
      customerId: json['customer_id'] as String,
      lines: (json['lines'] as List<dynamic>)
          .map((e) => QuotationLineInput.fromJson(e as Map<String, dynamic>))
          .toList(),
      priceDate: json['price_date'] == null
          ? null
          : DateTime.parse(json['price_date'] as String),
      quoteDate: json['quote_date'] == null
          ? null
          : DateTime.parse(json['quote_date'] as String),
    );

Map<String, dynamic> _$PricingPreviewInputToJson(
  PricingPreviewInput instance,
) => <String, dynamic>{
  'customer_id': instance.customerId,
  'lines': instance.lines,
  'price_date': ?instance.priceDate?.toIso8601String(),
  'quote_date': ?instance.quoteDate?.toIso8601String(),
};
