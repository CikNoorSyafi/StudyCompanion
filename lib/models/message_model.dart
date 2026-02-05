/// 🔹 Represents ONE message bubble inside a chat
class ChatMessage {
  final String sender; // "Parent" or "Teacher"
  final String text;

  ChatMessage({required this.sender, required this.text});
}

/// 🔹 Represents ONE conversation (chat thread)
class MessageModel {
  final String id;
  final String teacherName;
  final String studentName;
  String lastMessage;
  String time;
  bool unread;
  List<ChatMessage> messages; // 🔥 LIST OF CHAT BUBBLES

  MessageModel({
    required this.id,
    required this.teacherName,
    required this.studentName,
    required this.lastMessage,
    required this.time,
    required this.unread,
    required this.messages,
  });
}
