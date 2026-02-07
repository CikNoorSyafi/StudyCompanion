import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _school = TextEditingController();
  final _linkingCode = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _role = "parent";
  bool _loading = false;
  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _school.dispose();
    _linkingCode.dispose();
    super.dispose();
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final user = UserModel(
      name: _name.text,
      email: _email.text,
      password: _password.text,
      role: _role,
      school: _role == "teacher" ? _school.text : null,
      linkingCode: _role == "student" ? _linkingCode.text : null,
    );

    final result = await AuthService.register(user);

    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));

    if (result == "Registration successful") {
      Navigator.pop(context); // go back to Login screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Account")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextField(
                controller: _name,
                decoration: const InputDecoration(labelText: "Name"),
              ),

              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  }
                  if (!value.contains("@") || !value.contains(".com")) {
                    return "Enter a valid email (example@mail.com)";
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField(
                value: _role,
                items: const [
                  DropdownMenuItem(value: "parent", child: Text("Parent")),
                  DropdownMenuItem(value: "student", child: Text("Student")),
                  DropdownMenuItem(value: "teacher", child: Text("Teacher")),
                ],
                onChanged: (v) => setState(() => _role = v.toString()),
                decoration: const InputDecoration(labelText: "Role"),
              ),

              if (_role == "teacher")
                TextField(
                  controller: _school,
                  decoration: const InputDecoration(labelText: "School"),
                ),

              if (_role == "student")
                TextField(
                  controller: _linkingCode,
                  decoration: const InputDecoration(
                    labelText: "Student Linking Code",
                  ),
                ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _loading ? null : _register,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
