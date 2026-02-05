import 'package:flutter/material.dart';
import 'package:studycompanion_app/views/student_dashboard.dart';
import 'package:studycompanion_app/views/teacher_dashboard.dart';
import 'package:studycompanion_app/views/parent_dashboard.dart';
import 'package:studycompanion_app/views/admin_dashboard.dart';
import 'package:studycompanion_app/core/user_session.dart';

/// A self-contained login screen widget that mirrors the provided HTML layout.
/// Place this file in `lib/viewmodels/login_viewmodel.dart` and use
/// `LoginViewModel()` as a normal Flutter page/widget.
class LoginViewModel extends StatefulWidget {
  const LoginViewModel({super.key});

  @override
  State<LoginViewModel> createState() => _LoginViewModelState();
}

class _LoginViewModelState extends State<LoginViewModel> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  final List<String> _roles = ['Student', 'Parent', 'Teacher', 'Admin'];
  int _selectedRoleIndex = 0;

  Color get _primary => const Color(0xFFD41121);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF221012)
          : const Color(0xFFF8F6F6),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: _primary,
                          borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                            BoxShadow(
                              color: _primary.withAlpha((0.25 * 255).round()),
                              blurRadius: 12,
                              spreadRadius: -3,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.school,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Study Companion',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1B0D0F),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.help_outline,
                      color: isDark ? Colors.white70 : Colors.grey[600],
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12),
                      // Welcome
                      Column(
                        children: [
                          Text(
                            'Welcome Back',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1B0D0F),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Please select your role and sign in to continue your learning journey.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? Colors.grey[300]
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Role selector (segmented)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: isDark
                              ? Colors.white10
                              : Colors.grey.shade200.withAlpha((0.6 * 255).round()),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: List.generate(_roles.length, (i) {
                            final selected = i == _selectedRoleIndex;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedRoleIndex = i),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? (isDark ? _primary : Colors.white)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: selected
                                        ? [
                                            BoxShadow(
                        color: isDark
                          ? _primary.withAlpha((0.25 * 255).round())
                          : Colors.black12,
                                              blurRadius: 6,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    _roles[i],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: selected
                                          ? (isDark ? Colors.white : _primary)
                                          : (isDark
                                                ? Colors.grey[300]
                                                : Colors.grey[700]),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Form
                      Form(
                        child: Column(
                          children: [
                            // Email
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 4.0,
                                  bottom: 6,
                                ),
                                child: Text(
                                  'Email or Username',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark
                                        ? Colors.grey[300]
                                        : Colors.grey[800],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.person_outline,
                                  color: Colors.grey,
                                ),
                                hintText: 'Enter your email or ID',
                                filled: true,
                                fillColor: isDark
                                    ? Colors.white10
                                    : Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: isDark
                                        ? Colors.grey.shade700
                                        : Colors.grey.shade200,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(color: _primary),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),

                            const SizedBox(height: 16),

                            // Password
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 4.0,
                                  bottom: 6,
                                ),
                                child: Text(
                                  'Password',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark
                                        ? Colors.grey[300]
                                        : Colors.grey[800],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: Colors.grey,
                                ),
                                hintText: 'Enter your password',
                                filled: true,
                                fillColor: isDark
                                    ? Colors.white10
                                    : Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: isDark
                                        ? Colors.grey.shade700
                                        : Colors.grey.shade200,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(color: _primary),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey[600],
                                  ),
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                ),
                              ),
                            ),

                            // Forgot password
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 6.0,
                                  right: 2.0,
                                ),
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: _primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Sign In button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _primary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 8,
                                ),
                                onPressed: () {
                                  // Replace with your sign-in logic
                                  final selectedRole =
                                      _roles[_selectedRoleIndex];
                                  // ✅ STORE USER GLOBALLY (ADD HERE)
                                  UserSession.name =
                                      _emailController.text; // temp name
                                  UserSession.email = _emailController.text;
                                  UserSession.role = selectedRole;

                                  Widget destinationScreen;

                                  switch (selectedRole) {
                                    case 'Student':
                                      destinationScreen =
                                          const StudentDashboard();
                                      break;

                                    case 'Teacher':
                                      destinationScreen =
                                          const TeacherDashboard();
                                      break;

                                    case 'Parent':
                                      destinationScreen =
                                          const ParentDashboard();
                                      break;

                                    case 'Admin':
                                      destinationScreen =
                                          const AdminDashboard();
                                      break;

                                    default:
                                      destinationScreen =
                                          const StudentDashboard();
                                  }

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => destinationScreen,
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: _primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
