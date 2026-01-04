import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/register_screen.dart';
import 'screens/student/dashboard_screen.dart';
import 'screens/teacher/dashboard_screen.dart';
import 'screens/parent/dashboard_screen.dart';
import 'screens/admin/dashboard_screen.dart';

void main() {
  runApp(const StudyCompanionApp());
}

class StudyCompanionApp extends StatelessWidget {
  const StudyCompanionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'Study Companion',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: LoginScreen.routeName,
        routes: {
          LoginScreen.routeName: (_) => const LoginScreen(),
          ForgotPasswordScreen.routeName: (_) => const ForgotPasswordScreen(),
          RegisterScreen.routeName: (_) => const RegisterScreen(),
          StudentDashboardScreen.routeName: (_) => const StudentDashboardScreen(),
          TeacherDashboardScreen.routeName: (_) => const TeacherDashboardScreen(),
          ParentDashboardScreen.routeName: (_) => const ParentDashboardScreen(),
          AdminDashboardScreen.routeName: (_) => const AdminDashboardScreen(),
        },
      ),
    );
  }
}
