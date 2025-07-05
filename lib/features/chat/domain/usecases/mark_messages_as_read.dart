import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/chat/domain/repositories/chat_repository.dart';

class MarkMessagesAsRead implements UseCase<bool, MarkMessagesAsReadParams> {
  final ChatRepository repository;

  MarkMessagesAsRead(this.repository);

  @override
  Future<Either<Failure, bool>> call(MarkMessagesAsReadParams params) async {
    return await repository.markMessagesAsRead(params.chatId, params.userId);
  }
}

class MarkMessagesAsReadParams extends NoParams {
  final String chatId;
  final String userId;

  MarkMessagesAsReadParams({
    required this.chatId,
    required this.userId,
  });

  @override
  List<Object> get props => [chatId, userId];
}
