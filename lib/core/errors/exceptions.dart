class ServerException implements Exception {
  const ServerException({
    this.message = 'Server error occurred',
    this.statusCode,
  });
  final String message;
  final int? statusCode;

  @override
  String toString() =>
      'ServerException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class NetworkException implements Exception {
  const NetworkException({this.message = 'Network connection error'});
  final String message;

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  const CacheException({this.message = 'Cache error occurred'});
  final String message;

  @override
  String toString() => 'CacheException: $message';
}

class ValidationException implements Exception {
  const ValidationException({this.message = 'Validation error'});
  final String message;

  @override
  String toString() => 'ValidationException: $message';
}

class AuthenticationException implements Exception {
  const AuthenticationException({this.message = 'Authentication failed'});
  final String message;

  @override
  String toString() => 'AuthenticationException: $message';
}

class AuthorizationException implements Exception {
  const AuthorizationException({this.message = 'Authorization failed'});
  final String message;

  @override
  String toString() => 'AuthorizationException: $message';
}

class FileException implements Exception {
  const FileException({this.message = 'File operation failed'});
  final String message;

  @override
  String toString() => 'FileException: $message';
}

class PermissionException implements Exception {
  const PermissionException({this.message = 'Permission denied'});
  final String message;

  @override
  String toString() => 'PermissionException: $message';
}

class UnknownException implements Exception {
  const UnknownException({this.message = 'An unknown error occurred'});
  final String message;

  @override
  String toString() => 'UnknownException: $message';
}
