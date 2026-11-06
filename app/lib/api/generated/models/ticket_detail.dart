// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'article.dart';
import 'ticket.dart';

part 'ticket_detail.g.dart';

@JsonSerializable()
class TicketDetail {
  const TicketDetail({
    required this.articles,
    required this.ticket,
  });
  
  factory TicketDetail.fromJson(Map<String, Object?> json) => _$TicketDetailFromJson(json);
  
  final List<Article> articles;
  final Ticket ticket;

  Map<String, Object?> toJson() => _$TicketDetailToJson(this);
}
