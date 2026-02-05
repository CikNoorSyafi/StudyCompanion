import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studycompanion_app/viewmodels/student_dashboard_viewmodel.dart';
import 'package:studycompanion_app/viewmodels/announcement_viewmodel.dart';
import 'package:studycompanion_app/viewmodels/notification_viewmodel.dart';
import 'package:studycompanion_app/views/announcements_page.dart';
import 'package:studycompanion_app/views/notifications_page.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  static const primary = Color(0xFF800000);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StudentDashboardViewModel(),
      child: _buildScaffold(),
    );
  }

  Widget _buildScaffold() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      // 🔝 HEADER
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Row(
          children: [
            CircleAvatar(radius: 18, backgroundColor: Colors.grey),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi, Amir",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "STUDENT DASHBOARD",
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ChangeNotifierProvider(
              create: (_) => NotificationViewModel(),
              child: Consumer<NotificationViewModel>(
                builder: (context, notifyViewModel, _) {
                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications, color: primary),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                create: (_) => NotificationViewModel(),
                                child: const NotificationsPage(),
                              ),
                            ),
                          );
                        },
                      ),
                      if (notifyViewModel.unreadCount > 0)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              notifyViewModel.unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Consumer<StudentDashboardViewModel>(
          builder: (context, viewModel, _) {
            return Column(
              children: [
                // 📊 PROGRESS CARD
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF800000), Color(0xFF5C0000)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Overall Academic Progress",
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${viewModel.progressPercentage}%",
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: viewModel.overallProgress,
                          backgroundColor: Colors.white24,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${viewModel.completedTasksCount} of ${viewModel.totalTasksCount} tasks completed",
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),

                // ⏰ REMINDERS
                sectionTitle("Upcoming Reminders"),
                SizedBox(
                  height: 140,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: const [
                      ReminderCard("Physics Quiz", "Tomorrow, 10AM"),
                      ReminderCard("Science Club", "Wed, 3PM"),
                      ReminderCard("Return Books", "Fri, 5PM"),
                    ],
                  ),
                ),

                // � ANNOUNCEMENTS
                sectionTitle("Latest Announcements"),
                ChangeNotifierProvider(
                  create: (_) => AnnouncementViewModel(),
                  child: Consumer<AnnouncementViewModel>(
                    builder: (context, announcementViewModel, _) {
                      final announcements = announcementViewModel.recentAnnouncements;
                      if (announcements.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'No announcements yet',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        );
                      }
                      return Column(
                        children: [
                          ...announcements.take(2).map((announcement) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border(
                                    left: BorderSide(
                                      color: Colors.blue[800]!,
                                      width: 4,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      announcement.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      announcement.message,
                                      style: const TextStyle(fontSize: 12),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChangeNotifierProvider(
                                      create: (_) => AnnouncementViewModel(),
                                      child: const AnnouncementsPage(),
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[800],
                                minimumSize: const Size(double.infinity, 40),
                              ),
                              child: const Text('View All Announcements'),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                // 🔔 NOTIFICATIONS
                sectionTitle("Recent Notifications"),
                ChangeNotifierProvider(
                  create: (_) => NotificationViewModel(),
                  child: Consumer<NotificationViewModel>(
                    builder: (context, notifyViewModel, _) {
                      final notifications = notifyViewModel.recentNotifications;
                      if (notifications.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'No notifications yet',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        );
                      }
                      return Column(
                        children: [
                          ...notifications.take(3).map((notification) {
                            final iconData = _getNotificationIcon(notification.notificationType);
                            final color = _getNotificationColor(notification.notificationType);
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: notification.isRead ? Colors.grey[100] : Colors.amber[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: color.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Icon(iconData, color: color, size: 18),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            notification.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            notification.body,
                                            style: const TextStyle(fontSize: 11),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChangeNotifierProvider(
                                      create: (_) => NotificationViewModel(),
                                      child: const NotificationsPage(),
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber[800],
                                minimumSize: const Size(double.infinity, 40),
                              ),
                              child: const Text('View All Notifications'),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                // �📚 TASKS
                sectionTitle("Assigned Tasks"),
                ...viewModel.tasks.map((task) => TaskTile(task: task)),
                const SizedBox(height: 80),
              ],
            );
          },
        ),
      ),

      // 🔻 BOTTOM NAV + FAB
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Icon(Icons.dashboard, color: primary),
              Icon(Icons.school, color: Colors.grey),
              SizedBox(width: 40),
              Icon(Icons.calendar_month, color: Colors.grey),
              Icon(Icons.person, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  static Widget sectionTitle(String text) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

// 🔹 Reminder Card
class ReminderCard extends StatelessWidget {
  final String title;
  final String time;
  const ReminderCard(this.title, this.time, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.notifications, color: StudentDashboard.primary),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

// 🔹 Task Tile
class TaskTile extends StatelessWidget {
  final dynamic task;
  
  const TaskTile({required this.task, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentDashboardViewModel>(
      builder: (context, viewModel, _) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: task.isCompleted ? Colors.green : Colors.grey,
            child: Icon(
              task.isCompleted ? Icons.check : Icons.book,
              color: Colors.white,
            ),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              color: task.isCompleted ? Colors.grey : Colors.black,
            ),
          ),
          subtitle: Text(task.dueDate),
          trailing: GestureDetector(
            onTap: () => viewModel.toggleTaskCompletion(task.id),
            child: Icon(
              task.isCompleted
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: task.isCompleted
                  ? StudentDashboard.primary
                  : Colors.grey,
            ),
          ),
        );
      },
    );
  }
}
// 🔹 Helper Methods for Notifications
IconData _getNotificationIcon(String type) {
  switch (type) {
    case 'task':
      return Icons.assignment;
    case 'achievement':
      return Icons.emoji_events;
    case 'announcement':
      return Icons.notifications_active;
    case 'alert':
      return Icons.info;
    default:
      return Icons.notifications;
  }
}

Color _getNotificationColor(String type) {
  switch (type) {
    case 'task':
      return Colors.orange;
    case 'achievement':
      return Colors.green;
    case 'announcement':
      return Colors.blue;
    case 'alert':
      return Colors.red;
    default:
      return Colors.grey;
  }
}