// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Job _$JobFromJson(Map<String, dynamic> json) => Job(
  address: json['address'] as String,
  city: json['city'] as String,
  completionNotes: json['completion_notes'] as String,
  countryCode: json['country_code'] as String,
  customerId: json['customer_id'] as String,
  customerName: json['customer_name'] as String,
  id: json['id'] as String,
  instructions: json['instructions'] as String,
  kind: json['kind'] as String,
  number: json['number'] as String,
  postalCode: json['postal_code'] as String,
  priority: json['priority'] as String,
  siteName: json['site_name'] as String,
  status: json['status'] as String,
  street: json['street'] as String,
  tasksDone: (json['tasks_done'] as num).toInt(),
  tasksTotal: (json['tasks_total'] as num).toInt(),
  technicians: (json['technicians'] as List<dynamic>)
      .map((e) => Technician.fromJson(e as Map<String, dynamic>))
      .toList(),
  title: json['title'] as String,
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
  contactId: json['contact_id'] as String?,
  contactName: json['contact_name'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  mapsUrl: json['maps_url'] as String?,
  repairId: json['repair_id'] as String?,
  scheduledEnd: json['scheduled_end'] == null
      ? null
      : DateTime.parse(json['scheduled_end'] as String),
  scheduledStart: json['scheduled_start'] == null
      ? null
      : DateTime.parse(json['scheduled_start'] as String),
  startedAt: json['started_at'] == null
      ? null
      : DateTime.parse(json['started_at'] as String),
  ticketId: json['ticket_id'] as String?,
);

Map<String, dynamic> _$JobToJson(Job instance) => <String, dynamic>{
  'address': instance.address,
  'city': instance.city,
  'completed_at': ?instance.completedAt?.toIso8601String(),
  'completion_notes': instance.completionNotes,
  'contact_id': ?instance.contactId,
  'contact_name': ?instance.contactName,
  'country_code': instance.countryCode,
  'customer_id': instance.customerId,
  'customer_name': instance.customerName,
  'id': instance.id,
  'instructions': instance.instructions,
  'kind': instance.kind,
  'latitude': ?instance.latitude,
  'longitude': ?instance.longitude,
  'maps_url': ?instance.mapsUrl,
  'number': instance.number,
  'postal_code': instance.postalCode,
  'priority': instance.priority,
  'repair_id': ?instance.repairId,
  'scheduled_end': ?instance.scheduledEnd?.toIso8601String(),
  'scheduled_start': ?instance.scheduledStart?.toIso8601String(),
  'site_name': instance.siteName,
  'started_at': ?instance.startedAt?.toIso8601String(),
  'status': instance.status,
  'street': instance.street,
  'tasks_done': instance.tasksDone,
  'tasks_total': instance.tasksTotal,
  'technicians': instance.technicians,
  'ticket_id': ?instance.ticketId,
  'title': instance.title,
};
