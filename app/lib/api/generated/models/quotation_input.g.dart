// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuotationInput _$QuotationInputFromJson(Map<String, dynamic> json) =>
    QuotationInput(
      customerId: json['customer_id'] as String,
      lines: (json['lines'] as List<dynamic>)
          .map((e) => QuotationLineInput.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
      opportunityId: json['opportunity_id'] as String?,
      priceDate: json['price_date'] == null
          ? null
          : DateTime.parse(json['price_date'] as String),
      quoteDate: json['quote_date'] == null
          ? null
          : DateTime.parse(json['quote_date'] as String),
      validDays: (json['valid_days'] as num?)?.toInt(),
    );

Map<String, dynamic> _$QuotationInputToJson(QuotationInput instance) =>
    <String, dynamic>{
      'customer_id': instance.customerId,
      'lines': instance.lines,
      'notes': ?instance.notes,
      'opportunity_id': ?instance.opportunityId,
      'price_date': ?instance.priceDate?.toIso8601String(),
      'quote_date': ?instance.quoteDate?.toIso8601String(),
      'valid_days': ?instance.validDays,
    };
