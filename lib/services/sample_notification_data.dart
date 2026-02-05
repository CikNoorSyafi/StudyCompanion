import 'package:studycompanion_app/models/notification_model.dart';

class SampleNotificationData {
  /// Generate sample notifications for testing
  static List<NotificationModel> generateSampleNotifications({String studentId = 's1'}) {
    final now = DateTime.now();
    
    return [
      // Task notifications
      NotificationModel(
        id: 'notif_1',
        title: 'Task Reminder: Algebra Worksheet',
        body: 'Your task "Algebra Worksheet" for Mathematics is due today. Make sure to submit it before 5:00 PM.',
        studentId: studentId,
        notificationType: 'task',
        relatedEntityId: 'task_1',
        createdAt: now.subtract(const Duration(hours: 1)),
        isRead: false,
      ),
      NotificationModel(
        id: 'notif_2',
        title: 'Task Due Tomorrow: Chapter 4 Reading',
        body: 'English: Chapter 4 Reading assignment is due tomorrow. Please complete your reading and prepare answers to discussion questions.',
        studentId: studentId,
        notificationType: 'task',
        relatedEntityId: 'task_2',
        createdAt: now.subtract(const Duration(hours: 3)),
        isRead: true,
      ),
      NotificationModel(
        id: 'notif_3',
        title: 'Task Overdue: History Essay Outline',
        body: 'Your task "History Essay Outline" was due yesterday. Please contact Cikgu Mei Ling for extension request.',
        studentId: studentId,
        notificationType: 'task',
        relatedEntityId: 'task_4',
        createdAt: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
      
      // Achievement notifications
      NotificationModel(
        id: 'notif_4',
        title: 'Achievement Unlocked! 🏆',
        body: 'Congratulations! You have completed 5 tasks. Achievement: "Task Master" unlocked!',
        studentId: studentId,
        notificationType: 'achievement',
        relatedEntityId: 'achievement_1',
        createdAt: now.subtract(const Duration(days: 2)),
        isRead: true,
      ),
      NotificationModel(
        id: 'notif_5',
        title: 'Achievement Unlocked! 🌟',
        body: 'Amazing! You have achieved 80% progress. Achievement: "Star Student" unlocked!',
        studentId: studentId,
        notificationType: 'achievement',
        relatedEntityId: 'achievement_2',
        createdAt: now.subtract(const Duration(days: 3)),
        isRead: true,
      ),
      
      // Announcement notifications
      NotificationModel(
        id: 'notif_6',
        title: 'New Announcement: School Sports Day',
        body: 'New announcement published: School Sports Day - February 15, 2026. All students must participate in at least one event.',
        studentId: studentId,
        notificationType: 'announcement',
        relatedEntityId: 'ann_1',
        createdAt: now.subtract(const Duration(days: 2, hours: 5)),
        isRead: false,
      ),
      
      // Alert notifications
      NotificationModel(
        id: 'notif_7',
        title: 'Exam Schedule Alert',
        body: 'Mid-Year Examinations will start in 24 days. Make sure you are well-prepared. Timetable: March 1-20, 2026.',
        studentId: studentId,
        notificationType: 'alert',
        relatedEntityId: 'exam_1',
        createdAt: now.subtract(const Duration(days: 4)),
        isRead: true,
      ),
      NotificationModel(
        id: 'notif_8',
        title: 'Class Cancellation: PE Class Today',
        body: 'Alert: Physical Education class has been cancelled today (Feb 5) due to weather. Class will resume tomorrow as scheduled.',
        studentId: studentId,
        notificationType: 'alert',
        relatedEntityId: 'alert_1',
        createdAt: now.subtract(const Duration(hours: 30)),
        isRead: false,
      ),
      
      // More task notifications
      NotificationModel(
        id: 'notif_9',
        title: 'Task Assigned: Science Lab Report',
        body: 'New task assigned in Science: Submit your lab report for the Photosynthesis experiment. Due: February 18, 2026.',
        studentId: studentId,
        notificationType: 'task',
        relatedEntityId: 'task_5',
        createdAt: now.subtract(const Duration(days: 5)),
        isRead: true,
      ),
      
      // More achievement notifications
      NotificationModel(
        id: 'notif_10',
        title: 'Perfect Score! 💯',
        body: 'Excellent work! You scored 100% on the Mathematics quiz. Keep up the great work!',
        studentId: studentId,
        notificationType: 'achievement',
        relatedEntityId: 'achievement_3',
        createdAt: now.subtract(const Duration(days: 6)),
        isRead: true,
      ),
    ];
  }

  /// Generate sample notifications for a parent
  static List<NotificationModel> generateSampleParentNotifications({String parentId = 'p1'}) {
    final now = DateTime.now();
    
    return [
      NotificationModel(
        id: 'parent_notif_1',
        title: 'Child\'s Progress: 70% Task Completion',
        body: 'Your child Nurul Izzah has completed 70% of assigned tasks. Great progress!',
        parentId: parentId,
        notificationType: 'alert',
        createdAt: now.subtract(const Duration(hours: 5)),
        isRead: false,
      ),
      NotificationModel(
        id: 'parent_notif_2',
        title: 'Achievement: Nurul Izzah - Task Master',
        body: 'Your child has unlocked the "Task Master" achievement. She has completed 5 tasks successfully!',
        parentId: parentId,
        notificationType: 'achievement',
        createdAt: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationModel(
        id: 'parent_notif_3',
        title: 'Parent-Teacher Meeting Reminder',
        body: 'Reminder: Parent-Teacher Meeting scheduled for February 20, 2026 from 2:00 PM to 5:00 PM.',
        parentId: parentId,
        notificationType: 'announcement',
        createdAt: now.subtract(const Duration(days: 2)),
        isRead: true,
      ),
      NotificationModel(
        id: 'parent_notif_4',
        title: 'Important: Overdue Task Alert',
        body: 'Your child has an overdue task: History Essay Outline (due yesterday). Please follow up with the teacher.',
        parentId: parentId,
        notificationType: 'alert',
        createdAt: now.subtract(const Duration(days: 1)),
        isRead: false,
      ),
      NotificationModel(
        id: 'parent_notif_5',
        title: 'School Announcement: Examination Schedule',
        body: 'Mid-Year examinations schedule has been released. Examinations: March 1-20, 2026.',
        parentId: parentId,
        notificationType: 'announcement',
        createdAt: now.subtract(const Duration(days: 2)),
        isRead: true,
      ),
    ];
  }

  /// Get unread notifications count
  static int getUnreadCount(List<NotificationModel> notifications) {
    return notifications.where((n) => !n.isRead).length;
  }

  /// Get recent notifications (sorted by date, newest first)
  static List<NotificationModel> getRecentNotifications({
    String studentId = 's1',
    bool isStudent = true,
    int limit = 5,
  }) {
    final all = isStudent
        ? generateSampleNotifications(studentId: studentId)
        : generateSampleParentNotifications(parentId: studentId);
    
    // Sort by date descending
    all.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return all.take(limit).toList();
  }

  /// Get notifications by type
  static List<NotificationModel> getNotificationsByType(
    String type, {
    String studentId = 's1',
    bool isStudent = true,
  }) {
    final all = isStudent
        ? generateSampleNotifications(studentId: studentId)
        : generateSampleParentNotifications(parentId: studentId);
    
    return all.where((n) => n.notificationType == type).toList();
  }

  /// Get unread notifications
  static List<NotificationModel> getUnreadNotifications({
    String studentId = 's1',
    bool isStudent = true,
  }) {
    final all = isStudent
        ? generateSampleNotifications(studentId: studentId)
        : generateSampleParentNotifications(parentId: studentId);
    
    return all.where((n) => !n.isRead).toList();
  }

  /// Mark all as read (for testing)
  static List<NotificationModel> markAllAsRead(List<NotificationModel> notifications) {
    return notifications.map((n) => n.copyWith(isRead: true)).toList();
  }

  /// Create sample task reminder notification
  static NotificationModel createTaskReminderNotification({
    required String studentId,
    required String taskTitle,
    required String subject,
  }) {
    return NotificationModel(
      id: 'notif_custom_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Task Reminder: $taskTitle',
      body: '$subject: "$taskTitle" is due soon. Make sure to submit it on time.',
      studentId: studentId,
      notificationType: 'task',
      createdAt: DateTime.now(),
      isRead: false,
    );
  }

  /// Create sample achievement notification
  static NotificationModel createAchievementNotification({
    required String studentId,
    required String achievementName,
    required String description,
  }) {
    return NotificationModel(
      id: 'notif_custom_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Achievement Unlocked! 🏆',
      body: '$achievementName: $description',
      studentId: studentId,
      notificationType: 'achievement',
      createdAt: DateTime.now(),
      isRead: false,
    );
  }

  /// Create sample parent progress notification
  static NotificationModel createParentProgressNotification({
    required String parentId,
    required String childName,
    required String progressUpdate,
  }) {
    return NotificationModel(
      id: 'notif_custom_${DateTime.now().millisecondsSinceEpoch}',
      title: '$childName - Progress Update',
      body: progressUpdate,
      parentId: parentId,
      notificationType: 'alert',
      createdAt: DateTime.now(),
      isRead: false,
    );
  }
}
