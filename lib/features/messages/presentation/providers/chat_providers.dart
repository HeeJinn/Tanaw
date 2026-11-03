import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:b_risk/features/auth/presentation/providers/auth_providers.dart';
import 'package:b_risk/features/messages/data/repositories/chat_repository_impl.dart';
import 'package:b_risk/features/messages/domain/entities/chat.dart';
import 'package:b_risk/features/messages/domain/repositories/chat_repository.dart';

part 'chat_providers.g.dart';

@riverpod
ChatRepository chatRepository(Ref ref) {
  return ChatRepositoryImpl(firestore: FirebaseFirestore.instance);
}

@riverpod
Stream<List<ChatMessage>> chatMessages(Ref ref, String threadUid) {
  if (ref.watch(authUidProvider) == null) return const Stream.empty();
  return ref.watch(chatRepositoryProvider).watchMessages(threadUid);
}

@riverpod
Stream<ChatThread?> chatThread(Ref ref, String threadUid) {
  if (ref.watch(authUidProvider) == null) return const Stream.empty();
  return ref.watch(chatRepositoryProvider).watchThread(threadUid);
}

@riverpod
Stream<List<ChatThread>> chatThreads(Ref ref) {
  if (!ref.watch(isAdminProvider)) return const Stream.empty();
  return ref.watch(chatRepositoryProvider).watchThreads();
}
