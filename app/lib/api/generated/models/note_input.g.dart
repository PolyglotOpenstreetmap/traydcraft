// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteInput _$NoteInputFromJson(Map<String, dynamic> json) =>
    NoteInput(body: json['body'] as String, status: json['status'] as String?);

Map<String, dynamic> _$NoteInputToJson(NoteInput instance) => <String, dynamic>{
  'body': instance.body,
  'status': ?instance.status,
};
