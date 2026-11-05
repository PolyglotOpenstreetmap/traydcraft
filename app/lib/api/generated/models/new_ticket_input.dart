// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'new_ticket_input.g.dart';

/// A ticket opened by hand (phone call, visit, internal question).
@JsonSerializable()
class NewTicketInput {
  const NewTicketInput({
    required this.body,
    required this.subject,
    this.category,
    this.contactEmail,
    this.contactName,
    this.customerId,
    this.internal,
    this.language,
  });
  
  factory NewTicketInput.fromJson(Map<String, Object?> json) => _$NewTicketInputFromJson(json);
  
  /// First internal note (what was asked).
  final String body;
  @JsonKey(includeIfNull: false)
  final String? category;
  @JsonKey(includeIfNull: false,name: 'contact_email')
  final String? contactEmail;
  @JsonKey(includeIfNull: false,name: 'contact_name')
  final String? contactName;
  @JsonKey(includeIfNull: false,name: 'customer_id')
  final String? customerId;
  @JsonKey(includeIfNull: false)
  final bool? internal;

  /// Defaults to the customer's language, else the company's.
  @JsonKey(includeIfNull: false)
  final String? language;
  final String subject;

  Map<String, Object?> toJson() => _$NewTicketInputToJson(this);
}
