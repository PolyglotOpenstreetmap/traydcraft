// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) => Article(
  body: json['body'] as String,
  ccAddresses: (json['cc_addresses'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  createdAt: DateTime.parse(json['created_at'] as String),
  fromAddress: json['from_address'] as String,
  fromName: json['from_name'] as String,
  id: json['id'] as String,
  kind: json['kind'] as String,
  subject: json['subject'] as String,
  toAddresses: (json['to_addresses'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  authorName: json['author_name'] as String?,
  authorUserId: json['author_user_id'] as String?,
  delivery: json['delivery'] as String?,
  deliveryError: json['delivery_error'] as String?,
  language: json['language'] as String?,
  sentAt: json['sent_at'] == null
      ? null
      : DateTime.parse(json['sent_at'] as String),
);

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
  'author_name': ?instance.authorName,
  'author_user_id': ?instance.authorUserId,
  'body': instance.body,
  'cc_addresses': instance.ccAddresses,
  'created_at': instance.createdAt.toIso8601String(),
  'delivery': ?instance.delivery,
  'delivery_error': ?instance.deliveryError,
  'from_address': instance.fromAddress,
  'from_name': instance.fromName,
  'id': instance.id,
  'kind': instance.kind,
  'language': ?instance.language,
  'sent_at': ?instance.sentAt?.toIso8601String(),
  'subject': instance.subject,
  'to_addresses': instance.toAddresses,
};
