// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation_line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuotationLine _$QuotationLineFromJson(Map<String, dynamic> json) =>
    QuotationLine(
      description: json['description'] as String,
      lineDiscountPercent: json['line_discount_percent'] as String,
      lineTotal: json['line_total'] as String,
      listUnitPrice: json['list_unit_price'] as String,
      netUnitPrice: json['net_unit_price'] as String,
      position: (json['position'] as num).toInt(),
      priceConfirmed: json['price_confirmed'] as bool,
      pricingType: json['pricing_type'] as String,
      productCode: json['product_code'] as String,
      quantity: json['quantity'] as String,
      rebatePercent: json['rebate_percent'] as String,
      rebateSource: json['rebate_source'] as String,
      unit: json['unit'] as String,
      vatRate: json['vat_rate'] as String,
      productId: json['product_id'] as String?,
    );

Map<String, dynamic> _$QuotationLineToJson(QuotationLine instance) =>
    <String, dynamic>{
      'description': instance.description,
      'line_discount_percent': instance.lineDiscountPercent,
      'line_total': instance.lineTotal,
      'list_unit_price': instance.listUnitPrice,
      'net_unit_price': instance.netUnitPrice,
      'position': instance.position,
      'price_confirmed': instance.priceConfirmed,
      'pricing_type': instance.pricingType,
      'product_code': instance.productCode,
      'product_id': ?instance.productId,
      'quantity': instance.quantity,
      'rebate_percent': instance.rebatePercent,
      'rebate_source': instance.rebateSource,
      'unit': instance.unit,
      'vat_rate': instance.vatRate,
    };
