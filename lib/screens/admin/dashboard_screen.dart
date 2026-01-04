import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  static const routeName = '/admin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Semantics(
            label: 'Admin dashboard placeholder',
            child: Text('Admin dashboard (placeholder)', style: TextStyle(fontSize: 16)),
          ),
        ),
      ),
    );
  }
}
