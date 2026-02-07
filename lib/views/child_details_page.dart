import 'package:flutter/material.dart';
import 'package:studycompanion_app/models/child_model.dart';

class ChildDetailsPage extends StatelessWidget {
  final ChildModel child;

  const ChildDetailsPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(child.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 👤 Basic Info
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const Icon(Icons.school),
                title: Text(child.name),
                subtitle: Text(
                  "${child.grade} • overallAverage ${child.overallAverage}",
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 📚 Subjects
            const Text(
              "Subjects",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _infoTile("Mathematics", "A"),
            _infoTile("Science", "A-"),
            _infoTile("English", "B+"),

            const SizedBox(height: 20),

            /// 📅 Attendance
            const Text(
              "Attendance",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _infoTile("Present Days", "120"),
            _infoTile("Absent Days", "3"),

            const Spacer(),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const Icon(Icons.message),
              label: const Text("Message Teacher"),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
