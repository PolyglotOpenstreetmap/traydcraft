// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'holiday.dart';
import 'working_hours.dart';

part 'business_calendar.g.dart';

@JsonSerializable()
class BusinessCalendar {
  const BusinessCalendar({
    required this.enabled,
    required this.holidays,
    required this.hours,
    required this.timeZone,
  });
  
  factory BusinessCalendar.fromJson(Map<String, Object?> json) => _$BusinessCalendarFromJson(json);
  
  /// When off, SLA times are plain elapsed time.
  final bool enabled;
  final List<Holiday> holidays;
  final List<WorkingHours> hours;

  /// An IANA name such as `Europe/Brussels`.
  @JsonKey(name: 'time_zone')
  final String timeZone;

  Map<String, Object?> toJson() => _$BusinessCalendarToJson(this);
}
