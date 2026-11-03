import 'package:b_risk/features/auth/domain/entities/app_user.dart';
import 'package:b_risk/features/messages/domain/entities/chat.dart';

abstract class ChatRepository {
  /// Oldest first.
  Stream<List<ChatMessage>> watchMessages(String threadUid);

  /// One thread per resident, most recent first. Admins only.
  Stream<List<ChatThread>> watchThreads();

  Stream<ChatThread?> watchThread(String threadUid);

  Future<void> send({required String threadUid, required AppUser sender, required String text});
}
