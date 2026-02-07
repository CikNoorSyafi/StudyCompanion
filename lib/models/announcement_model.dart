import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementModel {
  final String id;
  final String title;
  final String message;
  final String createdBy; // teacher/admin
  final DateTime date;
  final bool isPublished;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.message,
    required this.createdBy,
    required this.date,
    required this.isPublished,
  });

  factory AnnouncementModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return AnnouncementModel(
      id: doc.id,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      createdBy: data['createdBy'] ?? '',
      date: (data['createdAt'] as Timestamp).toDate(),
      isPublished: data['isPublished'] ?? false,
    );
  }
}
