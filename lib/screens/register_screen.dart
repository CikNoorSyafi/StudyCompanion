import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static const routeName = '/register';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Semantics(
            label: 'Registration placeholder',
            child: Text('Registration is a placeholder in UI-only phase.', style: TextStyle(fontSize: 16)),
          ),
        ),
      ),
    );
  }
}
