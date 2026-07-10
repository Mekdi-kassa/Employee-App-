class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  ApiException({required this.message, this.statusCode, this.errorCode});

  @override
  String toString() => message;

  factory ApiException.networkError(String message) {
    return ApiException(message: message, errorCode: 'NETWORK_ERROR');
  }

  factory ApiException.timeoutError() {
    return ApiException(message: 'Request timeout. Check connection.', errorCode: 'TIMEOUT_ERROR');
  }

  factory ApiException.serverError(int statusCode, String message) {
    return ApiException(message: message, statusCode: statusCode, errorCode: 'SERVER_ERROR');
  }

  factory ApiException.unauthorized(String message) {
    return ApiException(message: message, statusCode: 401, errorCode: 'UNAUTHORIZED');
  }

  factory ApiException.validationError(Map<String, dynamic> errors) {
    final errorMessages = errors.entries.map((e) {
      final value = e.value;
      if (value is List) {
        final stringValues = value.whereType<String>().toList();
        return stringValues.isNotEmpty ? '${e.key}: ${stringValues.join(', ')}' : '${e.key}: ${value.toString()}';
      }
      return '${e.key}: ${value?.toString() ?? 'null'}';
    }).join('\n');
    
    return ApiException(message: errorMessages, statusCode: 400, errorCode: 'VALIDATION_ERROR');
  }

  factory ApiException.fromDioError(dynamic error) {
    return ApiException(message: error.toString(), errorCode: 'UNKNOWN_ERROR');
  }
}