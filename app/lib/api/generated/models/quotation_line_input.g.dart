// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation_line_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuotationLineInput _$QuotationLineInputFromJson(Map<String, dynamic> json) =>
    QuotationLineInput(
      productId: json['product_id'] as String,
      quantity: json['quantity'] as String,
      description: json['description'] as String?,
      lineDiscountPercent: json['line_discount_percent'] as String?,
    );

Map<String, dynamic> _$QuotationLineInputToJson(QuotationLineInput instance) =>
    <String, dynamic>{
      'description': ?instance.description,
      'line_discount_percent': ?instance.lineDiscountPercent,
      'product_id': instance.productId,
      'quantity': instance.quantity,
    };
