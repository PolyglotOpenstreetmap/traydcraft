// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_calendar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessCalendar _$BusinessCalendarFromJson(Map<String, dynamic> json) =>
    BusinessCalendar(
      enabled: json['enabled'] as bool,
      holidays: (json['holidays'] as List<dynamic>)
          .map((e) => Holiday.fromJson(e as Map<String, dynamic>))
          .toList(),
      hours: (json['hours'] as List<dynamic>)
          .map((e) => WorkingHours.fromJson(e as Map<String, dynamic>))
          .toList(),
      timeZone: json['time_zone'] as String,
    );

Map<String, dynamic> _$BusinessCalendarToJson(BusinessCalendar instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'holidays': instance.holidays,
      'hours': instance.hours,
      'time_zone': instance.timeZone,
    };
