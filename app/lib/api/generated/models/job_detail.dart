// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'job.dart';
import 'job_photo.dart';
import 'site_phone.dart';
import 'task.dart';
import 'work_log.dart';

part 'job_detail.g.dart';

@JsonSerializable()
class JobDetail {
  const JobDetail({
    required this.contactPhones,
    required this.job,
    required this.photos,
    required this.tasks,
    required this.travelMinutes,
    required this.workLogs,
    required this.workMinutes,
  });
  
  factory JobDetail.fromJson(Map<String, Object?> json) => _$JobDetailFromJson(json);
  
  /// Phone numbers of the person to meet, to call when arriving.
  @JsonKey(name: 'contact_phones')
  final List<SitePhone> contactPhones;
  final Job job;
  final List<JobPhoto> photos;
  final List<Task> tasks;
  @JsonKey(name: 'travel_minutes')
  final int travelMinutes;
  @JsonKey(name: 'work_logs')
  final List<WorkLog> workLogs;

  /// Total minutes of work and of travel logged so far.
  @JsonKey(name: 'work_minutes')
  final int workMinutes;

  Map<String, Object?> toJson() => _$JobDetailToJson(this);
}
