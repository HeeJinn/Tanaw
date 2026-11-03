/// Each resident has one conversation with the MDRRMO team at `chats/{residentUid}`.
class ChatThread {
  final String uid; // the resident's uid
  final String userName;
  final String? userPhone;
  final String lastMessage;
  final DateTime updatedAt;

  const ChatThread({
    required this.uid,
    required this.userName,
    this.userPhone,
    required this.lastMessage,
    required this.updatedAt,
  });
}

class ChatMessage {
  final String id;
  final String text;
  final String senderUid;
  final bool fromAdmin;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.senderUid,
    required this.fromAdmin,
    required this.createdAt,
  });
}
