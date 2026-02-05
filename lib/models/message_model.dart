/// 🔹 Represents ONE message bubble inside a chat
class ChatMessage {
  final String sender; // "Parent" or "Teacher"
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.sender,
    required this.text,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      sender: json['sender'] as String? ?? '',
      text: json['text'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }
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

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String? ?? '',
      teacherName: json['teacherName'] as String? ?? '',
      studentName: json['studentName'] as String? ?? '',
      lastMessage: json['lastMessage'] as String? ?? '',
      time: json['time'] as String? ?? '',
      unread: json['unread'] as bool? ?? false,
      messages: (json['messages'] as List? ?? [])
          .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teacherName': teacherName,
      'studentName': studentName,
      'lastMessage': lastMessage,
      'time': time,
      'unread': unread,
      'messages': messages.map((m) => m.toJson()).toList(),
    };
  }
}
