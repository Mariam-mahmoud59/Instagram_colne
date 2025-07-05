import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/chat/domain/entities/message.dart';
import 'package:instagram_clone/features/chat/domain/repositories/chat_repository.dart';

class SubscribeToMessages
    implements
        UseCase<Stream<Either<Failure, Message>>, SubscribeToMessagesParams> {
  final ChatRepository repository;

  SubscribeToMessages(this.repository);

  @override
  Future<Either<Failure, Stream<Either<Failure, Message>>>> call(
      SubscribeToMessagesParams params) async {
    return Right(repository.subscribeToMessages(params.chatId));
  }
}

class SubscribeToMessagesParams extends NoParams {
  final String chatId;

  SubscribeToMessagesParams({required this.chatId});

  @override
  List<Object> get props => [chatId];
}
