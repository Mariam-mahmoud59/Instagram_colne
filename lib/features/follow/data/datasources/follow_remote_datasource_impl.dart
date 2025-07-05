import 'package:instagram_clone/features/auth/domain/entities/user.dart';
import 'package:instagram_clone/features/follow/data/datasources/follow_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class FollowRemoteDataSourceImpl implements FollowRemoteDataSource {
  final supabase.SupabaseClient supabaseClient;
  FollowRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<void> followUser(
      {required String followerId, required String followingId}) async {}

  @override
  Future<void> unfollowUser(
      {required String followerId, required String followingId}) async {}

  @override
  Future<List<User>> getFollowers(String userId) async {
    return [];
  }

  @override
  Future<List<User>> getFollowing(String userId) async {
    return [];
  }

  @override
  Future<bool> checkFollowStatus(
      {required String currentUserId, required String targetUserId}) async {
    return false;
  }
}
