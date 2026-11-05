// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'article.g.dart';

@JsonSerializable()
class Article {
  const Article({
    required this.body,
    required this.ccAddresses,
    required this.createdAt,
    required this.fromAddress,
    required this.fromName,
    required this.id,
    required this.kind,
    required this.subject,
    required this.toAddresses,
    this.authorName,
    this.authorUserId,
    this.delivery,
    this.deliveryError,
    this.language,
    this.sentAt,
  });
  
  factory Article.fromJson(Map<String, Object?> json) => _$ArticleFromJson(json);
  
  @JsonKey(includeIfNull: false,name: 'author_name')
  final String? authorName;
  @JsonKey(includeIfNull: false,name: 'author_user_id')
  final String? authorUserId;
  final String body;
  @JsonKey(name: 'cc_addresses')
  final List<String> ccAddresses;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// For outgoing e-mail: queued | sent | failed
  @JsonKey(includeIfNull: false)
  final String? delivery;
  @JsonKey(includeIfNull: false,name: 'delivery_error')
  final String? deliveryError;
  @JsonKey(name: 'from_address')
  final String fromAddress;
  @JsonKey(name: 'from_name')
  final String fromName;
  final String id;

  /// email_in | email_out | note
  final String kind;
  @JsonKey(includeIfNull: false)
  final String? language;
  @JsonKey(includeIfNull: false,name: 'sent_at')
  final DateTime? sentAt;
  final String subject;
  @JsonKey(name: 'to_addresses')
  final List<String> toAddresses;

  Map<String, Object?> toJson() => _$ArticleToJson(this);
}
