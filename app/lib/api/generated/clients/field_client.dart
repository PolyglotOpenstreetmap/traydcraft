// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/complete_input.dart';
import '../models/done_input.dart';
import '../models/job.dart';
import '../models/job_detail.dart';
import '../models/job_input.dart';
import '../models/reason_input.dart';
import '../models/task_input.dart';
import '../models/work_log_input.dart';

part 'field_client.g.dart';

@RestApi()
abstract class FieldClient {
  factory FieldClient(Dio dio, {String? baseUrl}) = _FieldClient;

  /// All jobs the user may see, for planning.
  ///
  /// [q] - Searches number, title, customer and city.
  ///
  /// [status] - A status, or `active` for planned and in progress.
  ///
  /// [technician] - `me`, `none` (unassigned) or a user id.
  ///
  /// [from] - Jobs scheduled from this moment on.
  ///
  /// [to] - Jobs scheduled before this moment.
  @GET('/api/v1/field/jobs')
  Future<List<Job>> listJobs({
    @Query('q') String? q,
    @Query('status') String? status,
    @Query('technician') String? technician,
    @Query('customer_id') String? customerId,
    @Query('from') DateTime? from,
    @Query('to') DateTime? to,
  });

  @POST('/api/v1/field/jobs')
  Future<JobDetail> createJob({
    @Body() required JobInput body,
  });

  @GET('/api/v1/field/jobs/{id}')
  Future<JobDetail> getJob({
    @Path('id') required String id,
  });

  @PUT('/api/v1/field/jobs/{id}')
  Future<JobDetail> updateJob({
    @Path('id') required String id,
    @Body() required JobInput body,
  });

  /// Cancels a job (planners only).
  @POST('/api/v1/field/jobs/{id}/cancel')
  Future<JobDetail> cancelJob({
    @Path('id') required String id,
    @Body() required ReasonInput body,
  });

  @POST('/api/v1/field/jobs/{id}/complete')
  Future<JobDetail> completeJob({
    @Path('id') required String id,
    @Body() required CompleteInput body,
  });

  /// Adds a photo: the request body is the image (JPEG, PNG or WebP, at most 12 MB).
  ///
  /// [clientId] - A client-chosen id: uploading the same id again returns the first upload.
  @POST('/api/v1/field/jobs/{id}/photos')
  Future<JobDetail> uploadJobPhoto({
    @Path('id') required String id,
    @Body() required String body,
    @Query('caption') String? caption,
    @Query('filename') String? filename,
    @Query('client_id') String? clientId,
  });

  @GET('/api/v1/field/jobs/{id}/photos/{photo_id}')
  Future<String> getJobPhoto({
    @Path('id') required String id,
    @Path('photo_id') required String photoId,
  });

  /// Takes a completed or cancelled job back into work (planners only).
  @POST('/api/v1/field/jobs/{id}/reopen')
  Future<JobDetail> reopenJob({
    @Path('id') required String id,
  });

  /// Starts the job: the technician has arrived and begins. Starting twice changes nothing.
  @POST('/api/v1/field/jobs/{id}/start')
  Future<JobDetail> startJob({
    @Path('id') required String id,
  });

  @POST('/api/v1/field/jobs/{id}/tasks')
  Future<JobDetail> addJobTask({
    @Path('id') required String id,
    @Body() required TaskInput body,
  });

  /// Ticks or unticks a task. Setting the state it already has changes nothing, so retries are safe.
  @POST('/api/v1/field/jobs/{id}/tasks/{task_id}/done')
  Future<JobDetail> setJobTaskDone({
    @Path('id') required String id,
    @Path('task_id') required String taskId,
    @Body() required DoneInput body,
  });

  /// Logs time and notes of work (or travel) on a job, for the logged-in technician.
  @POST('/api/v1/field/jobs/{id}/work-logs')
  Future<JobDetail> addWorkLog({
    @Path('id') required String id,
    @Body() required WorkLogInput body,
  });

  /// The jobs assigned to me that still have to be done (plus those finished in the last week),.
  /// in the order of their appointment.
  @GET('/api/v1/field/my-jobs')
  Future<List<Job>> listMyJobs();
}
