import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/auth/domain/entities/user.dart';
import 'package:instagram_clone/features/explore/domain/repositories/explore_repository.dart';

class SearchUsers implements UseCase<List<User>, SearchUsersParams> {
  final ExploreRepository repository;

  SearchUsers(this.repository);

  @override
  Future<Either<Failure, List<User>>> call(SearchUsersParams params) async {
    // Add debounce logic in the UI layer before calling this
    if (params.query.trim().isEmpty) {
      return const Right([]); // Return empty list for empty query
    }
    return await repository.searchUsers(params.query);
  }
}

class SearchUsersParams extends Equatable {
  final String query;

  const SearchUsersParams({required this.query});

  @override
  List<Object> get props => [query];
}

