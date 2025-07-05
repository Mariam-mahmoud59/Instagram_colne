

class ApiConstants {
 
  // Specific endpoints for other APIs
  static const String externalApiUsersEndpoint = '/users';

  // API timeouts for external APIs
  static const Duration connectTimeout = Duration(seconds: 10 );
  static const Duration receiveTimeout = Duration(seconds: 10);
}
