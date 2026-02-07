import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/announcement_model.dart';

class AnnouncementService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<List<AnnouncementModel>> getPublishedAnnouncements() async {
    final snapshot = await _db
        .collection('announcements')
        .where('isPublished', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => AnnouncementModel.fromFirestore(doc))
        .toList();
  }
}
