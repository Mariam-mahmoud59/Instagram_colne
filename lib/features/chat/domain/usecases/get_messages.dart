import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/chat/domain/entities/message.dart';
import 'package:instagram_clone/features/chat/domain/repositories/chat_repository.dart';

class GetMessages implements UseCase<List<Message>, GetMessagesParams> {
  final ChatRepository repository;

  GetMessages(this.repository);

  @override
  Future<Either<Failure, List<Message>>> call(GetMessagesParams params) async {
    return await repository.getMessages(params.chatId);
  }
}

class GetMessagesParams extends NoParams {
  final String chatId;

  GetMessagesParams({required this.chatId});

  @override
  List<Object> get props => [chatId];
}
