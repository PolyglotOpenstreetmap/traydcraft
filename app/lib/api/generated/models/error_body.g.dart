// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorBody _$ErrorBodyFromJson(Map<String, dynamic> json) => ErrorBody(
  error: json['error'] as String,
  message: json['message'] as String,
);

Map<String, dynamic> _$ErrorBodyToJson(ErrorBody instance) => <String, dynamic>{
  'error': instance.error,
  'message': instance.message,
};
