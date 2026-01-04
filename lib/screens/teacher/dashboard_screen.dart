import 'package:flutter/material.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({Key? key}) : super(key: key);

  static const routeName = '/teacher';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teacher Dashboard')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Semantics(
            label: 'Teacher dashboard placeholder',
            child: Text('Teacher dashboard (placeholder)', style: TextStyle(fontSize: 16)),
          ),
        ),
      ),
    );
  }
}
