// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'count.dart';
import 'count_line.dart';

part 'count_detail.g.dart';

@JsonSerializable()
class CountDetail {
  const CountDetail({
    required this.count,
    required this.lines,
  });
  
  factory CountDetail.fromJson(Map<String, Object?> json) => _$CountDetailFromJson(json);
  
  final Count count;
  final List<CountLine> lines;

  Map<String, Object?> toJson() => _$CountDetailToJson(this);
}
