import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/chat/domain/entities/chat.dart';
import 'package:instagram_clone/features/chat/domain/repositories/chat_repository.dart';

class GetChats implements UseCase<List<Chat>, GetChatsParams> {
  final ChatRepository repository;

  GetChats(this.repository);

  @override
  Future<Either<Failure, List<Chat>>> call(GetChatsParams params) async {
    return await repository.getChats(params.userId);
  }
}

class GetChatsParams extends NoParams {
  final String userId;

  GetChatsParams({required this.userId});

  @override
  List<Object> get props => [userId];
}
