// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/me.dart';

part 'core_client.g.dart';

@RestApi()
abstract class CoreClient {
  factory CoreClient(Dio dio, {String? baseUrl}) = _CoreClient;

  @GET('/api/v1/me')
  Future<Me> me();
}
