// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketDetail _$TicketDetailFromJson(Map<String, dynamic> json) => TicketDetail(
  articles: (json['articles'] as List<dynamic>)
      .map((e) => Article.fromJson(e as Map<String, dynamic>))
      .toList(),
  ticket: Ticket.fromJson(json['ticket'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TicketDetailToJson(TicketDetail instance) =>
    <String, dynamic>{'articles': instance.articles, 'ticket': instance.ticket};
