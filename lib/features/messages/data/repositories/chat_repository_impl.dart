import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:b_risk/features/auth/domain/entities/app_user.dart';
import 'package:b_risk/features/messages/domain/entities/chat.dart';
import 'package:b_risk/features/messages/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestore firestore;

  const ChatRepositoryImpl({required this.firestore});

  // Server timestamps read as null until the write lands
  static DateTime _time(Object? t) => (t as Timestamp?)?.toDate() ?? DateTime.now();

  static ChatThread _thread(String uid, Map<String, dynamic> json) => ChatThread(
        uid: uid,
        userName: json['userName'] as String? ?? 'Resident',
        userPhone: json['userPhone'] as String?,
        lastMessage: json['lastMessage'] as String? ?? '',
        updatedAt: _time(json['updatedAt']),
      );

  @override
  Stream<List<ChatMessage>> watchMessages(String threadUid) {
    return firestore
        .collection('chats/$threadUid/messages')
        .orderBy('createdAt')
        .limitToLast(200)
        .snapshots()
        .map((snap) => [
              for (final d in snap.docs)
                ChatMessage(
                  id: d.id,
                  text: d['text'] as String,
                  senderUid: d['senderUid'] as String,
                  fromAdmin: d['fromAdmin'] as bool,
                  createdAt: _time(d.data()['createdAt']),
                ),
            ]);
  }

  @override
  Stream<List<ChatThread>> watchThreads() {
    return firestore
        .collection('chats')
        .orderBy('updatedAt', descending: true)
        .limit(200)
        .snapshots()
        .map((snap) => [for (final d in snap.docs) _thread(d.id, d.data())]);
  }

  @override
  Stream<ChatThread?> watchThread(String threadUid) {
    return firestore.doc('chats/$threadUid').snapshots().map((d) => d.exists ? _thread(d.id, d.data()!) : null);
  }

  @override
  Future<void> send({required String threadUid, required AppUser sender, required String text}) {
    final thread = firestore.doc('chats/$threadUid');
    return (firestore.batch()
          ..set(
            thread,
            {
              'lastMessage': text,
              'updatedAt': FieldValue.serverTimestamp(),
              // Only the resident's own messages may set who the thread belongs to
              if (!sender.isAdmin) ...{'userName': sender.name, 'userPhone': ?sender.phone},
            },
            SetOptions(merge: true),
          )
          ..set(thread.collection('messages').doc(), {
            'text': text,
            'senderUid': sender.uid,
            'fromAdmin': sender.isAdmin,
            'createdAt': FieldValue.serverTimestamp(),
          }))
        .commit();
  }
}
