import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure({this.message = 'Server error occurred'});
  final String message;

  @override
  List<Object> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure({this.message = 'Network connection error'});
  final String message;

  @override
  List<Object> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure({this.message = 'Cache error occurred'});
  final String message;

  @override
  List<Object> get props => [message];
}

class ValidationFailure extends Failure {
  const ValidationFailure({this.message = 'Validation error'});
  final String message;

  @override
  List<Object> get props => [message];
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({this.message = 'Authentication failed'});
  final String message;

  @override
  List<Object> get props => [message];
}

class AuthorizationFailure extends Failure {
  const AuthorizationFailure({this.message = 'Authorization failed'});
  final String message;

  @override
  List<Object> get props => [message];
}

class FileFailure extends Failure {
  const FileFailure({this.message = 'File operation failed'});
  final String message;

  @override
  List<Object> get props => [message];
}

class PermissionFailure extends Failure {
  const PermissionFailure({this.message = 'Permission denied'});
  final String message;

  @override
  List<Object> get props => [message];
}

class UnknownFailure extends Failure {
  const UnknownFailure({this.message = 'An unknown error occurred'});
  final String message;

  @override
  List<Object> get props => [message];
}
