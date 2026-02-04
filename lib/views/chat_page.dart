import 'package:flutter/material.dart';
import '../models/message_model.dart';

class ChatPage extends StatefulWidget {
  final MessageModel message;

  const ChatPage({super.key, required this.message});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  // 🔥 Local message list (temporary before DB)
  final List<Map<String, String>> _chat = [
    {"sender": "teacher", "text": "Hello parent, just updating progress."},
    {"sender": "parent", "text": "Thank you teacher!"},
    {"sender": "teacher", "text": "Quiz tomorrow."},
  ];

  void _sendMessage() {
    if (_controller.text.isEmpty) return;

    setState(() {
      widget.message.messages.add(
        ChatMessage(sender: "Parent", text: _controller.text),
      );
      widget.message.lastMessage = _controller.text;
      widget.message.time = "Now";
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.message.teacherName),
        backgroundColor: const Color(0xFF800020),
      ),
      body: Column(
        children: [
          /// 💬 Messages list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _chat.length,
              itemBuilder: (context, index) {
                final msg = _chat[index];
                final isParent = msg["sender"] == "parent";

                return Align(
                  alignment: isParent
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isParent ? const Color(0xFF800020) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      msg["text"]!,
                      style: TextStyle(
                        color: isParent ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          /// ✏ Input bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF800020)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
