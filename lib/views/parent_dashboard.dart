import 'package:flutter/material.dart';
import 'package:studycompanion_app/core/user_session.dart';
import 'package:studycompanion_app/views/edit_profile_page.dart';
import 'package:studycompanion_app/views/notification_settings_page.dart';
import 'package:studycompanion_app/views/change_password_page.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:studycompanion_app/services/parent_service.dart';
import 'package:studycompanion_app/models/child_model.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ParentHomePage(),
    ParentMessagesPage(),
    ParentCalendarPage(),
    ParentProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF800020),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: "Messages",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Calendar",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🏠 HOME PAGE (Parent Dashboard Main Screen)
////////////////////////////////////////////////////////////

class ParentHomePage extends StatefulWidget {
  const ParentHomePage({super.key});

  @override
  State<ParentHomePage> createState() => _ParentHomePageState();
}

class _ParentHomePageState extends State<ParentHomePage> {
  late Future<List<ChildModel>> _childrenFuture;
  ChildModel? _selectedChild;

  @override
  void initState() {
    super.initState();
    _childrenFuture = ParentService.getChildren();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<ChildModel>>(
        future: _childrenFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading children"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No children found"));
          }

          final children = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 👋 Greeting
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Good Morning, ${UserSession.name} 👋",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                /// 🎓 CHILDREN LIST
                ...children.map(
                  (child) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedChild = child;
                      });
                    },
                    child: DashboardCard(
                      title: child.name,
                      subtitle: child.grade,
                      trailing: "GPA ${child.gpa}",
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 📚 TODAY'S FOCUS
                const SectionTitle("Today's Focus"),

                if (_selectedChild == null)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("Select a child to see today's learning focus"),
                  )
                else ...[
                  FocusCard(
                    title: "📚 ${_selectedChild!.name}'s Homework",
                    subtitle: _selectedChild!.homework,
                  ),
                  FocusCard(
                    title: "📝 Upcoming Quiz",
                    subtitle: _selectedChild!.quiz,
                  ),
                  FocusCard(
                    title: "📌 Reminder",
                    subtitle: _selectedChild!.reminder,
                  ),
                ],

                const SizedBox(height: 20),

                /// 📊 PERFORMANCE
                const SectionTitle("Performance"),
                const DashboardCard(
                  title: "Weekly Average",
                  subtitle: "88%",
                  trailing: "+2.4%",
                ),

                const SizedBox(height: 20),

                /// 📢 ANNOUNCEMENTS
                const SectionTitle("Announcements"),
                const DashboardCard(
                  title: "Science Fair Update",
                  subtitle: "Due next Friday",
                  trailing: "",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 💬 MESSAGES PAGE
////////////////////////////////////////////////////////////

class ParentMessagesPage extends StatelessWidget {
  const ParentMessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Messages with Teachers",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 📅 CALENDAR PAGE
////////////////////////////////////////////////////////////

class ParentCalendarPage extends StatelessWidget {
  const ParentCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "School Calendar",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 👤 PROFILE PAGE
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
/// 👤 PROFILE PAGE
////////////////////////////////////////////////////////////

class ParentProfilePage extends StatefulWidget {
  const ParentProfilePage({super.key});

  @override
  State<ParentProfilePage> createState() => _ParentProfilePageState();
}

class _ParentProfilePageState extends State<ParentProfilePage> {
  /// 📸 Pick image from gallery
  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        UserSession.profileImagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        // ✅ FIXED OVERFLOW HERE
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// 👤 PROFILE IMAGE WITH CAMERA ICON
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: UserSession.profileImagePath.isNotEmpty
                      ? FileImage(File(UserSession.profileImagePath))
                      : null,
                  child: UserSession.profileImagePath.isEmpty
                      ? const Icon(Icons.person, size: 40, color: Colors.white)
                      : null,
                ),

                GestureDetector(
                  onTap: () => _pickImage(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              UserSession.name.isEmpty ? "Parent User" : UserSession.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            Text(UserSession.email),
            Text(UserSession.phone),

            const SizedBox(height: 30),

            /// ⚙ SETTINGS OPTIONS
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Edit Profile"),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfilePage()),
                );
                setState(() {});
              },
            ),

            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Notification Settings"),
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (_) => const NotificationSettingsPage(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text("Change Password"),
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
                );
              },
            ),

            const SizedBox(height: 40),

            /// 🚪 LOGOUT BUTTON
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                ),
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                onPressed: () {
                  UserSession.name = "";
                  UserSession.email = "";
                  UserSession.role = "";
                  UserSession.phone = "";
                  UserSession.profileImagePath = "";

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 REUSABLE WIDGETS
////////////////////////////////////////////////////////////

class DashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailing;

  const DashboardCard({
    required this.title,
    required this.subtitle,
    required this.trailing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(subtitle),
              ],
            ),
            Text(trailing, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class FocusCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const FocusCard({required this.title, required this.subtitle, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(subtitle),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
