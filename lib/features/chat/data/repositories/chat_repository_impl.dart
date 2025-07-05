import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:instagram_clone/core/error/failures.dart';
// import 'package:instagram_clone/core/network/network_info.dart'; // Optional: Add network check if needed
import 'package:instagram_clone/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:instagram_clone/features/auth/domain/entities/user.dart';
import 'package:instagram_clone/features/auth/domain/repositories/auth_repository.dart';
import 'package:instagram_clone/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:instagram_clone/features/chat/domain/entities/chat.dart';
import 'package:instagram_clone/features/chat/domain/entities/message.dart';
import 'package:instagram_clone/features/chat/domain/repositories/chat_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  // final NetworkInfo networkInfo; // Optional: Inject if network check is needed

  AuthRepositoryImpl({
    required this.remoteDataSource,
    // required this.networkInfo,
  });

  Future<Either<Failure, T>> _handleAuthOperation<T>(
      Future<T> Function() operation) async {
    // Optional: Check network connectivity first
    // if (!await networkInfo.isConnected) {
    //   return Left(NetworkFailure());
    // }
    try {
      final result = await operation();
      return Right(result);
    } on supabase.AuthException catch (e) {
      // Map specific Supabase auth errors to custom Failures
      // Example mapping (adjust based on Supabase error messages):
      if (e.message.toLowerCase().contains('invalid login credentials')) {
        return Left(const AuthenticationFailure('Invalid email or password.'));
      } else if (e.message.toLowerCase().contains('user already registered')) {
        return Left(const AuthenticationFailure('Email already in use.'));
      } else if (e.message
          .toLowerCase()
          .contains('email rate limit exceeded')) {
        return Left(const AuthenticationFailure(
            'Too many attempts. Please try again later.'));
      }
      // Add more specific mappings as needed
      return Left(AuthenticationFailure(e.message)); // Generic auth failure
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      // Catch other potential exceptions (e.g., network issues not caught by NetworkInfo)
      return Left(UnknownFailure(
          message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return await _handleAuthOperation<User>(() {
      return remoteDataSource.loginWithEmailPassword(
          email: email, password: password);
    });
  }

  @override
  Future<Either<Failure, User>> signupWithEmailPassword({
    required String email,
    required String password,
    String? username,
  }) async {
    return await _handleAuthOperation<User>(() {
      return remoteDataSource.signupWithEmailPassword(
          email: email, password: password, username: username);
    });
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    // Getting current user might not need network check initially, depends on Supabase caching
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      // Handle potential errors during local/cached user retrieval if applicable
      return Left(UnknownFailure(
          message: 'Failed to get current user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    return await _handleAuthOperation<void>(() {
      return remoteDataSource.logout();
    });
  }
}

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Chat>>> getChats(String userId) async {
    try {
      final chats = await remoteDataSource.getChats(userId);
      return Right(chats);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Chat>> getOrCreateChat(
      String currentUserId, String otherUserId) async {
    try {
      final chat =
          await remoteDataSource.getOrCreateChat(currentUserId, otherUserId);
      return Right(chat);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages(String chatId) async {
    try {
      final messages = await remoteDataSource.getMessages(chatId);
      return Right(messages);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> markMessagesAsRead(
      String chatId, String userId) async {
    try {
      final result = await remoteDataSource.markMessagesAsRead(chatId, userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage(
      String chatId, String senderId, String receiverId, String content) async {
    try {
      final message = await remoteDataSource.sendMessage(
          chatId, senderId, receiverId, content);
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Chat>> getChatById(String chatId) async {
    try {
      // This would need to be implemented in the data source
      // For now, we'll throw an exception
      throw ServerException(message: 'getChatById not implemented');
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<Chat>>> subscribeToChats(String userId) {
    return remoteDataSource
        .subscribeToChats(userId)
        .map<Either<Failure, List<Chat>>>((chats) => Right(chats))
        .handleError((error) {
      if (error is ServerException) {
        return Left(ServerFailure(message: error.message));
      }
      return Left(UnknownFailure(message: error.toString()));
    });
  }

  @override
  Stream<Either<Failure, Message>> subscribeToMessages(String chatId) {
    return remoteDataSource
        .subscribeToMessages(chatId)
        .map<Either<Failure, Message>>((message) => Right(message))
        .handleError((error) {
      if (error is ServerException) {
        return Left(ServerFailure(message: error.message));
      }
      return Left(UnknownFailure(message: error.toString()));
    });
  }
}
