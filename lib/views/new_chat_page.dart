import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/message_service.dart';

class NewChatPage extends StatefulWidget {
  final String chatId;

  const NewChatPage({super.key, required this.chatId});

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: Center(child: Text("Chat ID: ${widget.chatId}")),
    );
  }
}
