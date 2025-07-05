import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/chat/domain/entities/chat.dart';
import 'package:instagram_clone/features/chat/domain/repositories/chat_repository.dart';

class GetOrCreateChat implements UseCase<Chat, GetOrCreateChatParams> {
  final ChatRepository repository;

  GetOrCreateChat(this.repository);

  @override
  Future<Either<Failure, Chat>> call(GetOrCreateChatParams params) async {
    return await repository.getOrCreateChat(
        params.currentUserId, params.otherUserId);
  }
}

class GetOrCreateChatParams extends NoParams {
  final String currentUserId;
  final String otherUserId;

  GetOrCreateChatParams({
    required this.currentUserId,
    required this.otherUserId,
  });

  @override
  List<Object> get props => [currentUserId, otherUserId];
}
