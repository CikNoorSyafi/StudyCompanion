import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studycompanion_app/models/notification_model.dart';
import 'package:studycompanion_app/services/sample_notification_data.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _notificationsCollection = 'notifications';
  static bool useSampleData = true; // Toggle for testing

  /// Initialize Firebase Messaging
  static Future<void> initializeMessaging() async {
    try {
      // Request notification permissions
      await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        criticalAlert: true,
        provisional: false,
        sound: true,
      );

      // Get FCM token
      final token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');

      // Handle foreground notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Received foreground notification: ${message.notification?.title}');
        _handleNotification(message);
      });

      // Handle when app is opened from notification
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('Opened app from notification: ${message.notification?.title}');
        _handleNotification(message);
      });

      // Handle background notifications
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      print('Firebase Messaging initialized successfully');
    } catch (e) {
      print('Error initializing Firebase Messaging: $e');
    }
  }

  /// Background message handler
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Handling background notification: ${message.notification?.title}');
    // Handle background notification
  }

  /// Handle incoming notification
  static void _handleNotification(RemoteMessage message) {
    final notification = message.notification;
    final data = message.data;

    if (notification != null) {
      print('Notification - Title: ${notification.title}, Body: ${notification.body}');
      // You can add custom logic here to handle notifications
    }

    if (data.isNotEmpty) {
      print('Notification data: $data');
      // Handle custom data from notification
    }
  }

  /// Send notification to student
  static Future<void> sendTaskReminderNotification({
    required String studentId,
    required String taskTitle,
    required String dueDate,
  }) async {
    try {
      final notificationId = _firestore.collection(_notificationsCollection).doc().id;

      final notification = NotificationModel(
        id: notificationId,
        title: 'Task Reminder',
        body: 'Your task "$taskTitle" is due on $dueDate',
        studentId: studentId,
        notificationType: 'task',
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection(_notificationsCollection)
          .doc(notificationId)
          .set(notification.toJson());

      print('Task reminder sent to student: $studentId');
    } catch (e) {
      print('Error sending task reminder: $e');
      rethrow;
    }
  }

  /// Send achievement notification
  static Future<void> sendAchievementNotification({
    required String studentId,
    required String achievement,
  }) async {
    try {
      final notificationId = _firestore.collection(_notificationsCollection).doc().id;

      final notification = NotificationModel(
        id: notificationId,
        title: 'Achievement Unlocked!',
        body: 'Great job! You have unlocked: $achievement',
        studentId: studentId,
        notificationType: 'achievement',
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection(_notificationsCollection)
          .doc(notificationId)
          .set(notification.toJson());

      print('Achievement notification sent to student: $studentId');
    } catch (e) {
      print('Error sending achievement notification: $e');
      rethrow;
    }
  }

  /// Send parent notification about child's progress
  static Future<void> sendParentProgressNotification({
    required String parentId,
    required String childName,
    required String progressUpdate,
  }) async {
    try {
      final notificationId = _firestore.collection(_notificationsCollection).doc().id;

      final notification = NotificationModel(
        id: notificationId,
        title: '$childName - Progress Update',
        body: progressUpdate,
        parentId: parentId,
        notificationType: 'alert',
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection(_notificationsCollection)
          .doc(notificationId)
          .set(notification.toJson());

      print('Parent notification sent to: $parentId');
    } catch (e) {
      print('Error sending parent notification: $e');
      rethrow;
    }
  }

  /// Get student's notifications from Firestore or sample data
  static Future<List<NotificationModel>> getStudentNotifications(
      String studentId) async {
    // Use sample data for testing/demo purposes
    if (useSampleData) {
      return SampleNotificationData.generateSampleNotifications();
    }
    
    try {
      final querySnapshot = await _firestore
          .collection(_notificationsCollection)
          .where('studentId', isEqualTo: studentId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => NotificationModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching student notifications: $e');
      // Fallback to sample data on error
      return SampleNotificationData.generateSampleNotifications();
    }
  }

  /// Stream student's notifications for real-time updates
  static Stream<List<NotificationModel>> streamStudentNotifications(
      String studentId) {
    return _firestore
        .collection(_notificationsCollection)
        .where('studentId', isEqualTo: studentId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => NotificationModel.fromJson(doc.data()))
            .toList());
  }

  /// Get parent's notifications from Firestore or sample data
  static Future<List<NotificationModel>> getParentNotifications(
      String parentId) async {
    // Use sample data for testing/demo purposes
    if (useSampleData) {
      return SampleNotificationData.generateSampleParentNotifications();
    }
    
    try {
      final querySnapshot = await _firestore
          .collection(_notificationsCollection)
          .where('parentId', isEqualTo: parentId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => NotificationModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching parent notifications: $e');
      // Fallback to sample data on error
      return SampleNotificationData.generateSampleParentNotifications();
    }
  }

  /// Stream parent's notifications for real-time updates
  static Stream<List<NotificationModel>> streamParentNotifications(
      String parentId) {
    return _firestore
        .collection(_notificationsCollection)
        .where('parentId', isEqualTo: parentId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => NotificationModel.fromJson(doc.data()))
            .toList());
  }

  /// Get unread notification count
  static Future<int> getUnreadCount(String userId, {bool isStudent = true}) async {
    try {
      final field = isStudent ? 'studentId' : 'parentId';
      final querySnapshot = await _firestore
          .collection(_notificationsCollection)
          .where(field, isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      return querySnapshot.size;
    } catch (e) {
      print('Error getting unread count: $e');
      return 0;
    }
  }

  /// Mark notification as read
  static Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _firestore
          .collection(_notificationsCollection)
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      print('Error marking notification as read: $e');
      rethrow;
    }
  }

  /// Get recent notifications for dashboard (last 5) from Firestore or sample data
  static Future<List<NotificationModel>> getRecentNotifications(
    String userId, {
    bool isStudent = true,
    int limit = 5,
  }) async {
    // Use sample data for testing/demo purposes
    if (useSampleData) {
      final allNotifications = isStudent
          ? SampleNotificationData.generateSampleNotifications()
          : SampleNotificationData.generateSampleParentNotifications();
      return allNotifications.take(limit).toList();
    }
    
    try {
      final field = isStudent ? 'studentId' : 'parentId';
      final querySnapshot = await _firestore
          .collection(_notificationsCollection)
          .where(field, isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => NotificationModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching recent notifications: $e');
      // Fallback to sample data on error
      final allNotifications = isStudent
          ? SampleNotificationData.generateSampleNotifications()
          : SampleNotificationData.generateSampleParentNotifications();
      return allNotifications.take(limit).toList();
    }
  }
}
