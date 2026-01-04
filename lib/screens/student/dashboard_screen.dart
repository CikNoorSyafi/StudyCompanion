import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/password_input_field.dart';
import '../../widgets/primary_button.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({Key? key}) : super(key: key);

  static const routeName = '/student';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;

    // If no user is logged in, redirect to login screen
    if (user == null) {
      // Navigate after frame to avoid build-time navigation
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);
    final sampleCourses = <String>['Mathematics', 'English', 'Science', 'History'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.school, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Text('Study Companion', style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor)),
        ]),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.grey,
            onPressed: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
            tooltip: 'Logout',
          )
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: 28, child: Text(user.name.isNotEmpty ? user.name[0] : 'S')),
                    const SizedBox(width: 12),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Welcome back,', style: TextStyle(color: Colors.grey[700])),
                      Text(user.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(user.role.name.toUpperCase(), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ])
                  ],
                ),

                const SizedBox(height: 20),

                const Text('Your Courses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: sampleCourses.map((c) {
                    return Container(
                      width: 220,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)]),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(c, style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        const Text('Next: Chapter 3 — due tomorrow', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 8),
                        PrimaryButton(label: 'Open', onPressed: () {}),
                      ]),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
