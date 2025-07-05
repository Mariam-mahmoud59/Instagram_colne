import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/settings/data/datasources/settings_remote_datasource.dart';
import 'package:instagram_clone/features/settings/domain/entities/settings.dart';
import 'package:instagram_clone/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;

  SettingsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Settings>> getSettings(String userId) async {
    try {
      final settings = await remoteDataSource.getSettings(userId);
      return Right(settings);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Settings>> updateLanguage(String userId, String language) async {
    try {
      await remoteDataSource.updateLanguage(userId, language);
      final settings = await remoteDataSource.getSettings(userId);
      return Right(settings);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Settings>> updateNotificationsEnabled(String userId, bool enabled) async {
    try {
      await remoteDataSource.updateNotificationsEnabled(userId, enabled);
      final settings = await remoteDataSource.getSettings(userId);
      return Right(settings);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Settings>> updateThemeMode(String userId, ThemeMode themeMode) async {
    try {
      await remoteDataSource.updateThemeMode(userId, themeMode);
      final settings = await remoteDataSource.getSettings(userId);
      return Right(settings);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
