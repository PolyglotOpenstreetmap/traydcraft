// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'task_input.g.dart';

@JsonSerializable()
class TaskInput {
  const TaskInput({
    required this.description,
  });
  
  factory TaskInput.fromJson(Map<String, Object?> json) => _$TaskInputFromJson(json);
  
  final String description;

  Map<String, Object?> toJson() => _$TaskInputToJson(this);
}
