import 'package:flutter/material.dart';
import 'package:studycompanion_app/core/user_session.dart';
import 'package:studycompanion_app/views/edit_profile_page.dart';
import 'package:studycompanion_app/views/notification_settings_page.dart';
import 'package:studycompanion_app/views/change_password_page.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:studycompanion_app/services/parent_service.dart';
import 'package:studycompanion_app/models/child_model.dart';
import 'package:studycompanion_app/models/announcement_model.dart';
import 'package:studycompanion_app/services/announcement_service.dart';
import 'package:studycompanion_app/models/message_model.dart';
import 'package:studycompanion_app/services/message_service.dart';
import 'package:studycompanion_app/views/chat_page.dart';
import 'package:studycompanion_app/views/new_chat_page.dart';
import 'package:studycompanion_app/services/calendar_service.dart';
import 'package:studycompanion_app/models/event_model.dart';
import 'package:studycompanion_app/services/study_task_service.dart';
import 'package:studycompanion_app/models/study_task_model.dart';
import 'package:studycompanion_app/services/calendar_service.dart';
import 'package:studycompanion_app/views/add_study_task_page.dart';
import 'package:studycompanion_app/views/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  late Future<List<AnnouncementModel>> _announcementFuture;

  @override
  void initState() {
    super.initState();
    _childrenFuture = ParentService.getChildren().then((children) {
      if (children.isNotEmpty) {
        _selectedChild = children.first;
      }
      return children;
    });
    _announcementFuture =
        AnnouncementService.getPublishedAnnouncements(); // Fetch announcements
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
            final TextEditingController _codeController =
                TextEditingController();

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "No children linked yet",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: _codeController,
                      decoration: const InputDecoration(
                        labelText: "Enter Linking Code",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () async {
                        final result = await ParentService.linkChild(
                          _codeController.text.trim(),
                        );

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(result)));

                        if (result == "Child linked successfully") {
                          final children = await ParentService.getChildren();

                          setState(() {
                            _childrenFuture = Future.value(children);
                            if (children.isNotEmpty) {
                              _selectedChild = children.first;
                            }
                          });
                        }
                      },

                      child: const Text("Link Child"),
                    ),
                  ],
                ),
              ),
            );
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
                      trailing:
                          "Average ${child.overallAverage.toStringAsFixed(1)}%",
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                /// 📚 TODAY'S FOCUS
                const SectionTitle("Today's Focus"),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _selectedChild == null
                      ? const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text("Select a child to see today's focus"),
                        )
                      : GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.6,
                          children: [
                            FocusCard(
                              title: "Homework",
                              subtitle: _selectedChild?.homework ?? "",
                              icon: Icons.menu_book_rounded,
                              color: const Color(0xFF4A90E2),
                            ),
                            FocusCard(
                              title: "Quiz",
                              subtitle: _selectedChild?.quiz ?? "",
                              icon: Icons.quiz_rounded,
                              color: const Color(0xFF9B59B6),
                            ),
                            FocusCard(
                              title: "Reminder",
                              subtitle: _selectedChild?.reminder ?? "",
                              icon: Icons.push_pin_rounded,
                              color: const Color(0xFFF39C12),
                            ),
                          ],
                        ),
                ),

                const SizedBox(height: 16),

                /// 📊 PERFORMANCE
                const SectionTitle("Performance"),

                if (_selectedChild == null)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("Select a child to see performance"),
                  )
                else
                  Column(
                    children: [
                      // 🔥 SUBJECT SCORES (from DB)
                      ..._selectedChild!.subjects.map((subj) {
                        return ProgressCard(
                          subject: subj.subjectName,
                          score: subj.score,
                        );
                      }).toList(),

                      const SizedBox(height: 12),

                      // 📊 Attendance
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE3F2FD), Colors.white],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Attendance",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: _selectedChild!.attendance / 100,
                                  minHeight: 10,
                                  backgroundColor: Colors.grey.shade200,
                                  valueColor: const AlwaysStoppedAnimation(
                                    Color(0xFF1976D2),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "${_selectedChild!.attendance}%",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 📝 Teacher Remark
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F3FF),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.school,
                              color: Color(0xFF8E44AD),
                              size: 26,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Teacher Remark",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(_selectedChild!.teacherRemark),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),

                /// 📢 ANNOUNCEMENTS
                const SectionTitle("Announcements"),
                FutureBuilder<List<AnnouncementModel>>(
                  future: _announcementFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("No announcements available"),
                      );
                    }

                    final announcements = snapshot.data!;

                    return Column(
                      children: announcements.map((a) {
                        return DashboardCard(
                          title: a.title,
                          subtitle: a.message,
                          trailing: "",
                        );
                      }).toList(),
                    );
                  },
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
    return Scaffold(
      appBar: AppBar(title: const Text("Messages")),
      body: StreamBuilder<QuerySnapshot>(
        stream: MessageService.getParentChats(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final chats = snapshot.data!.docs;

          if (chats.isEmpty) {
            return const Center(child: Text("No messages yet"));
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final data = chats[index].data() as Map<String, dynamic>;

              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.school)),
                title: Text(data['teacherName'] ?? ''),
                subtitle: Text(data['lastMessage'] ?? ''),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatPage(chatId: chats[index].id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 📅 CALENDAR PAGE
////////////////////////////////////////////////////////////
class ParentCalendarPage extends StatefulWidget {
  const ParentCalendarPage({super.key});

  @override
  State<ParentCalendarPage> createState() => _ParentCalendarPageState();
}

class _ParentCalendarPageState extends State<ParentCalendarPage> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final schoolEvents = CalendarService.events
        .where(
          (e) =>
              e.date.year == selectedDate.year &&
              e.date.month == selectedDate.month &&
              e.date.day == selectedDate.day,
        )
        .toList();

    final studyTasks = StudyTaskService.getTasksByDate(selectedDate);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF800020),
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddStudyTaskPage(date: selectedDate),
            ),
          );
          setState(() {});
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            /// 📆 Simple Date Picker
            CalendarDatePicker(
              initialDate: selectedDate,
              firstDate: DateTime(2025),
              lastDate: DateTime(2030),
              onDateChanged: (d) => setState(() => selectedDate = d),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  /// SCHOOL EVENTS (READ ONLY)
                  const Text(
                    "School Events",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...schoolEvents.map(
                    (e) => ListTile(
                      title: Text(e.title),
                      subtitle: Text(e.description),
                      leading: const Icon(Icons.school),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// STUDY PLANNER (PARENT CRUD)
                  const Text(
                    "Study Planner",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...studyTasks.map(
                    (task) => CheckboxListTile(
                      title: Text("${task.subject} — ${task.topic}"),
                      subtitle: Text("${task.durationMinutes} mins"),
                      value: task.completed,
                      onChanged: (_) {
                        setState(() {
                          StudyTaskService.toggleComplete(task.id);
                        });
                      },
                      secondary: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            StudyTaskService.deleteTask(task.id);
                          });
                        },
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
            const SizedBox(height: 16),

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),

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
  final IconData icon;
  final Color color;

  const FocusCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(subtitle),
              ],
            ),
          ),
        ],
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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ProgressCard extends StatelessWidget {
  final String subject;
  final int score;

  const ProgressCard({required this.subject, required this.score, super.key});

  Color get _mainMaroon => const Color(0xFF800020); // primary
  Color get _lightMaroon => const Color(0xFFB76E79); // soft badge
  Color get _veryLightMaroon => const Color(0xFFF4E6E8); // card tint
  Color get _color {
    if (score >= 85) {
      return _mainMaroon; // Strong performance
    } else if (score >= 70) {
      return _lightMaroon; // Medium
    } else {
      return _veryLightMaroon; // Needs improvement
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),

      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_veryLightMaroon, Colors.white],

            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Subject + score row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "$score%",
                    style: TextStyle(
                      color: _color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: score / 100,
                minHeight: 10,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation(Color(0xFF800020)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
