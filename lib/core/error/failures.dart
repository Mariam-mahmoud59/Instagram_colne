import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties;
  const Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object> get props => [properties];

  // Add a message getter for convenience
  String get message {
    if (properties.isNotEmpty && properties.first is String) {
      return properties.first as String;
    }
    return 'Unknown error occurred';
  }
}

// General failures
class ServerFailure extends Failure {
  final String? _message;
  const ServerFailure({String? message}) : _message = message;

  @override
  List<Object> get props => [_message ?? 'Server Failure'];

  @override
  String get message => _message ?? 'Server Failure';
}

class CacheFailure extends Failure {
  final String? _message;
  const CacheFailure({String? message}) : _message = message;

  @override
  List<Object> get props => [_message ?? 'Cache Failure'];

  @override
  String get message => _message ?? 'Cache Failure';
}

class NetworkFailure extends Failure {
  final String? _message;
  const NetworkFailure({String? message}) : _message = message;

  @override
  List<Object> get props => [_message ?? 'Network Failure'];

  @override
  String get message => _message ?? 'Network Failure';
}

class AuthenticationFailure extends Failure {
  final String _message;
  const AuthenticationFailure(String message) : _message = message;

  @override
  List<Object> get props => [_message];

  @override
  String get message => _message;
}

class UnknownFailure extends Failure {
  final String? _message;
  const UnknownFailure({String? message}) : _message = message;

  @override
  List<Object> get props => [_message ?? 'Unknown Failure'];

  @override
  String get message => _message ?? 'Unknown Failure';
}

class SupabaseFailure extends Failure {
  final String? _message;
  final String? _code;
  const SupabaseFailure({String? message, String? code})
      : _message = message,
        _code = code;

  @override
  List<Object> get props => [_message ?? 'Supabase Failure', _code ?? ''];

  @override
  String get message => _message ?? 'Supabase Failure';
}

class UnexpectedFailure extends Failure {
  final String? _message;
  const UnexpectedFailure({String? message}) : _message = message;

  @override
  List<Object> get props => [_message ?? 'Unexpected Failure'];

  @override
  String get message => _message ?? 'Unexpected Failure';
}
