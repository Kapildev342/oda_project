// Package imports:
import 'package:dio/dio.dart';

abstract class BaseApiService {
  Future<dynamic> getInitialFunction({required String url, required Map<String, dynamic> query, required String method, CancelToken? globalCancelToken});
}
