// lib/core/error/exceptions.dart

/// General server exception
class ServerException implements Exception {
  final String message;
  
  ServerException({this.message = 'Server error occurred'});
}

/// Exception when there is no internet connection
class NetworkException implements Exception {
  final String message;
  
  NetworkException({this.message = 'No internet connection'});
}

/// Exception when requested data is not found
class NotFoundException implements Exception {
  final String message;
  
  NotFoundException({this.message = 'Requested data not found'});
}

/// Authentication exception (when user is unauthorized)
class AuthException implements Exception {
  final String message;
  
  AuthException({this.message = 'Authentication error'});
}

/// Exception when there is a validation error
class ValidationException implements Exception {
  final String message;
  
  ValidationException({this.message = 'Invalid data'});
}

/// Exception when there is a database error
class DatabaseException implements Exception {
  final String message;
  
  DatabaseException({this.message = 'Database error'});
}

/// Exception when there is a local storage error
class CacheException implements Exception {
  final String message;
  
  CacheException({this.message = 'Cache error'});
}

/// Exception when there is a file upload error
class FileUploadException implements Exception {
  final String message;
  
  FileUploadException({this.message = 'File upload error'});
}

/// Exception when there is a Supabase error
class SupabaseException implements Exception {
  final String message;
  final String? code;
  
  SupabaseException({required this.message, this.code});
}
