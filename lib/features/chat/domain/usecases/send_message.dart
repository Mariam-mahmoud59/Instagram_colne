import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/chat/domain/entities/message.dart';
import 'package:instagram_clone/features/chat/domain/repositories/chat_repository.dart';

class SendMessage implements UseCase<Message, SendMessageParams> {
  final ChatRepository repository;

  SendMessage(this.repository);

  @override
  Future<Either<Failure, Message>> call(SendMessageParams params) async {
    return await repository.sendMessage(
      params.chatId,
      params.senderId,
      params.receiverId,
      params.content,
    );
  }
}

class SendMessageParams extends NoParams {
  final String chatId;
  final String senderId;
  final String receiverId;
  final String content;

  SendMessageParams({
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.content,
  });

  @override
  List<Object> get props => [chatId, senderId, receiverId, content];
}
