import 'package:dio/dio.dart';

/// Normalised error surfaced to the domain/presentation layers.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  /// Maps Dio failures (and FastAPI's `{"detail": ...}` error body) to a readable message.
  factory ApiException.fromDio(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;
    String? detail;
    if (data is Map && data['detail'] != null) {
      final d = data['detail'];
      detail = d is String ? d : (d is List && d.isNotEmpty ? d.first['msg']?.toString() : null);
    }
    final message =
        detail ??
        switch (e.type) {
          DioExceptionType.connectionTimeout ||
          DioExceptionType.sendTimeout ||
          DioExceptionType.receiveTimeout => 'The connection timed out. Please try again.',
          DioExceptionType.connectionError => 'No internet connection.',
          DioExceptionType.cancel => 'Request cancelled.',
          _ =>
            status == 401
                ? 'Your session has expired. Please log in again.'
                : 'Something went wrong. Please try again.',
        };
    return ApiException(message, statusCode: status);
  }

  @override
  String toString() => message;
}
