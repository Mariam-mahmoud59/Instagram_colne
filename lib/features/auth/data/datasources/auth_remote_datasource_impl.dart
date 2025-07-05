import 'package:supabase_flutter/supabase_flutter.dart'
    hide User, AuthException;
import '../../domain/entities/user.dart';
import '../../../../core/error/exceptions.dart';
import 'auth_remote_datasource.dart';

/// Implementation of [AuthRemoteDataSource] that interacts with Supabase.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<User?> getCurrentUser() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user != null) {
        return User(
          id: user.id,
          email: user.email ?? '',
          username: user.userMetadata?['username'] ?? user.email?.split('@')[0],
        );
      } else {
        return null;
      }
    } on PostgrestException catch (e) {
      throw SupabaseException(message: e.message, code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<User> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response =
          await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return User(
          id: response.user!.id,
          email: response.user!.email ?? '',
          username: response.user!.userMetadata?['username'] ??
              response.user!.email?.split('@')[0],
        );
      } else {
        throw AuthException(message: 'Login failed: No user returned.');
      }
    } on PostgrestException catch (e) {
      throw SupabaseException(message: e.message, code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<User> signupWithEmailPassword({
    required String email,
    required String password,
    String? username,
  }) async {
    try {
      final AuthResponse response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: username != null ? {'username': username} : null,
      );

      if (response.user != null) {
        return User(
          id: response.user!.id,
          email: response.user!.email ?? '',
          username: username ?? response.user!.email?.split('@')[0],
        );
      } else {
        throw AuthException(message: 'Signup failed: No user returned.');
      }
    } on PostgrestException catch (e) {
      throw SupabaseException(message: e.message, code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await supabaseClient.auth.signOut();
    } on PostgrestException catch (e) {
      throw SupabaseException(message: e.message, code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
