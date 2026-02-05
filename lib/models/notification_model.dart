class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String? studentId;
  final String? parentId;
  final String notificationType; // 'task', 'achievement', 'announcement', 'alert'
  final String? relatedEntityId; // Task ID, Achievement ID, etc.
  final DateTime createdAt;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.studentId,
    this.parentId,
    required this.notificationType,
    this.relatedEntityId,
    required this.createdAt,
    this.isRead = false,
  });

  // Convert NotificationModel to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'studentId': studentId,
      'parentId': parentId,
      'notificationType': notificationType,
      'relatedEntityId': relatedEntityId,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }

  // Create NotificationModel from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      studentId: json['studentId'],
      parentId: json['parentId'],
      notificationType: json['notificationType'] ?? 'alert',
      relatedEntityId: json['relatedEntityId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      isRead: json['isRead'] ?? false,
    );
  }

  // Copy with method for immutability
  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? studentId,
    String? parentId,
    String? notificationType,
    String? relatedEntityId,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      studentId: studentId ?? this.studentId,
      parentId: parentId ?? this.parentId,
      notificationType: notificationType ?? this.notificationType,
      relatedEntityId: relatedEntityId ?? this.relatedEntityId,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  String toString() =>
      'Notification(id: $id, title: $title, type: $notificationType, read: $isRead)';
}
