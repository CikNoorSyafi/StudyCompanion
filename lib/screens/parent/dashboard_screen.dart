import 'package:flutter/material.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({Key? key}) : super(key: key);

  static const routeName = '/parent';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parent Dashboard')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Semantics(
            label: 'Parent dashboard placeholder',
            child: Text('Parent dashboard (placeholder)', style: TextStyle(fontSize: 16)),
          ),
        ),
      ),
    );
  }
}
