import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_role.dart';
import '../models/login_request.dart';
import '../providers/auth_provider.dart';
import '../widgets/role_chip.dart';
import '../widgets/password_input_field.dart';
import '../widgets/primary_button.dart';

// TODO: Implement full login UI and wire to AuthProvider
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  UserRole _selectedRole = UserRole.student;
  String _error = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: theme.primaryColor.withOpacity(0.18), blurRadius: 12)],
              ),
              child: const Icon(Icons.school, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Text('Study Companion', style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            color: Colors.grey[500],
            onPressed: () {},
            tooltip: 'Help',
          )
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                const SizedBox(height: 8),
                const Text('Welcome Back', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Please select your role and sign in to access your dashboard.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),

                // Role selector (4 columns grid-like)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: theme.cardColor.withOpacity(0.8), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.withOpacity(0.2))),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    alignment: WrapAlignment.center,
                    children: [
                      RoleChip(label: 'Student', selected: _selectedRole == UserRole.student, onTap: () => setState(() => _selectedRole = UserRole.student)),
                      RoleChip(label: 'Parent', selected: _selectedRole == UserRole.parent, onTap: () => setState(() => _selectedRole = UserRole.parent)),
                      RoleChip(label: 'Teacher', selected: _selectedRole == UserRole.teacher, onTap: () => setState(() => _selectedRole = UserRole.teacher)),
                      RoleChip(label: 'Admin', selected: _selectedRole == UserRole.admin, onTap: () => setState(() => _selectedRole = UserRole.admin)),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email/ID
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Email or ID',
                          prefixIcon: const Icon(Icons.mail_outline),
                          filled: true,
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Colors.grey[100],
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),

                      // Password
                      PasswordInputField(controller: _passwordController),
                      const SizedBox(height: 6),
                      Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () {}, child: const Text('Forgot Password?'))),

                      const SizedBox(height: 12),

                      // Sign in
                      Consumer<AuthProvider>(builder: (context, auth, _) {
                        return PrimaryButton(
                          label: 'Sign In',
                          isLoading: auth.isLoading,
                          onPressed: auth.isLoading
                              ? null
                              : () async {
                                  if (!(_formKey.currentState?.validate() ?? false)) return;
                                  final req = LoginRequest(username: _usernameController.text.trim(), password: _passwordController.text, role: _selectedRole);
                                  final ok = await auth.login(req);
                                  if (ok && auth.currentUser != null) {
                                    final route = _routeForRole(auth.currentUser!.role);
                                    if (route != null) Navigator.pushReplacementNamed(context, route);
                                  } else {
                                    setState(() => _error = auth.error ?? 'Login failed');
                                  }
                                },
                        );
                      }),
                      if (_error.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(_error, style: const TextStyle(color: Colors.red)),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 18),
                // Footer
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("Don't have an account?", style: TextStyle(color: Colors.grey)),
                  TextButton(onPressed: () {}, child: const Text('Sign up'))
                ])
              ],
            ),
          ),
        ),
      ),
    );
    );

  String? _routeForRole(UserRole role) {
    switch (role) {
      case UserRole.student:
        return '/student';
      case UserRole.teacher:
        return '/teacher';
      case UserRole.parent:
        return '/parent';
      case UserRole.admin:
        return '/admin';
    }
  }
  }
}
