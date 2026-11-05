// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pricing_preview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PricingPreview _$PricingPreviewFromJson(Map<String, dynamic> json) =>
    PricingPreview(
      customerDiscountPercent: json['customer_discount_percent'] as String,
      lines: (json['lines'] as List<dynamic>)
          .map((e) => QuotationLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      priceZoneCode: json['price_zone_code'] as String,
      quoteDate: DateTime.parse(json['quote_date'] as String),
      subtotal: json['subtotal'] as String,
      total: json['total'] as String,
      vatGroups: (json['vat_groups'] as List<dynamic>)
          .map((e) => VatGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
      vatTotal: json['vat_total'] as String,
    );

Map<String, dynamic> _$PricingPreviewToJson(PricingPreview instance) =>
    <String, dynamic>{
      'customer_discount_percent': instance.customerDiscountPercent,
      'lines': instance.lines,
      'price_zone_code': instance.priceZoneCode,
      'quote_date': instance.quoteDate.toIso8601String(),
      'subtotal': instance.subtotal,
      'total': instance.total,
      'vat_groups': instance.vatGroups,
      'vat_total': instance.vatTotal,
    };
