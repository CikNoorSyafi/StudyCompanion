import 'package:flutter/material.dart';
import '../services/teacher_service.dart';
import '../models/teacher_model.dart';

import '../services/message_service.dart';
import 'chat_page.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({super.key});

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  late Future<List<TeacherModel>> _teachersFuture;

  @override
  void initState() {
    super.initState();

    // 🔥 Example: subjects from selected child
    List<String> childSubjects = ["Math", "English", "Science"];

    _teachersFuture = TeacherService.getTeachersForChildSubjects(childSubjects);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Start New Chat")),
      body: FutureBuilder<List<TeacherModel>>(
        future: _teachersFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final teachers = snapshot.data!;

          return ListView.builder(
            itemCount: teachers.length,
            itemBuilder: (context, index) {
              final teacher = teachers[index];

              return ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFF4E6E8),
                  child: Icon(Icons.school, color: Color(0xFF800020)),
                ),
                title: Text(teacher.name),
                subtitle: Text(teacher.subject),
                onTap: () {
                  final chat = MessageService.createNewChat(teacher.name);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => ChatPage(message: chat)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
