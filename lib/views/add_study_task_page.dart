import 'package:flutter/material.dart';
import 'package:studycompanion_app/models/study_task_model.dart';
import 'package:studycompanion_app/services/study_task_service.dart';

class AddStudyTaskPage extends StatefulWidget {
  final DateTime date;
  const AddStudyTaskPage({super.key, required this.date});

  @override
  State<AddStudyTaskPage> createState() => _AddStudyTaskPageState();
}

class _AddStudyTaskPageState extends State<AddStudyTaskPage> {
  final subjectCtrl = TextEditingController();
  final topicCtrl = TextEditingController();
  final durationCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Study Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: subjectCtrl,
              decoration: const InputDecoration(labelText: "Subject"),
            ),
            TextField(
              controller: topicCtrl,
              decoration: const InputDecoration(labelText: "Topic"),
            ),
            TextField(
              controller: durationCtrl,
              decoration: const InputDecoration(labelText: "Duration (mins)"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF800020),
              ),
              onPressed: () {
                StudyTaskService.addTask(
                  StudyTaskModel(
                    id: DateTime.now().toString(),
                    studentId: "1",
                    subject: subjectCtrl.text,
                    topic: topicCtrl.text,
                    date: widget.date,
                    durationMinutes: int.parse(durationCtrl.text),
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text("Save Task"),
            ),
          ],
        ),
      ),
    );
  }
}
