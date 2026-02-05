import '../models/message_model.dart';

class MessageService {
  /// 🔥 STORES ALL CONVERSATIONS IN MEMORY
  static final List<MessageModel> _messages = [
    MessageModel(
      id: "1",
      teacherName: "Mr. Daniel",
      studentName: "Alex Johnson",
      lastMessage: "Quiz tomorrow",
      time: "10:30 AM",
      unread: true,
      messages: [
        ChatMessage(
          sender: "Teacher",
          text: "Hello parent, just updating progress.",
        ),
      ],
    ),
    MessageModel(
      id: "2",
      teacherName: "Ms. Sara",
      studentName: "Emma Johnson",
      lastMessage: "Homework submitted",
      time: "Yesterday",
      unread: false,
      messages: [
        ChatMessage(sender: "Teacher", text: "Great improvement this week!"),
      ],
    ),
  ];

  /// 📥 LOAD MESSAGE LIST
  static Future<List<MessageModel>> getMessages() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _messages;
  }

  /// 🆕 CREATE NEW CHAT WHEN PARENT STARTS CONVERSATION
  static MessageModel createNewChat(String teacherName) {
    final newChat = MessageModel(
      id: DateTime.now().toString(),
      teacherName: teacherName,
      studentName: "Your Child",
      lastMessage: "",
      time: "Now",
      unread: false,
      messages: [],
    );

    _messages.insert(0, newChat);
    return newChat;
  }
}
