import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/chat/domain/entities/chat.dart';
import 'package:instagram_clone/features/chat/domain/repositories/chat_repository.dart';

class SubscribeToChats
    implements
        UseCase<Stream<Either<Failure, List<Chat>>>, SubscribeToChatsParams> {
  final ChatRepository repository;

  SubscribeToChats(this.repository);

  @override
  Future<Either<Failure, Stream<Either<Failure, List<Chat>>>>> call(
      SubscribeToChatsParams params) async {
    return Right(repository.subscribeToChats(params.userId));
  }
}

class SubscribeToChatsParams extends NoParams {
  final String userId;

  SubscribeToChatsParams({required this.userId});

  @override
  List<Object> get props => [userId];
}
