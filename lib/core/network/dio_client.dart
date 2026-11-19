import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../storage/preferences.dart';
import 'api_exception.dart';

/// Shared Dio instance configured for the DinoArena FastAPI backend.
final dioProvider = Provider<Dio>((ref) {
  final prefs = ref.watch(appPreferencesProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      headers: {'Accept': 'application/json', 'X-Client': 'dinoarena-mobile'},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = prefs.authToken;
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
      onError: (e, handler) => handler.reject(
        DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          type: e.type,
          error: ApiException.fromDio(e),
        ),
      ),
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: false, logPrint: (o) => debugPrint(o.toString())),
    );
  }
  return dio;
});

/// Runs a Dio call and converts failures into [ApiException].
Future<T> guardApi<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on DioException catch (e) {
    throw e.error is ApiException ? e.error! : ApiException.fromDio(e);
  }
}
