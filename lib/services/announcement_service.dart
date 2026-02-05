import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studycompanion_app/models/announcement_model.dart';
import 'package:studycompanion_app/services/sample_announcement_data.dart';

class AnnouncementService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'announcements';
  static bool useSampleData = true; // Toggle for testing

  /// Get all published announcements from Firestore or sample data
  static Future<List<AnnouncementModel>> getPublishedAnnouncements() async {
    // Use sample data for testing/demo purposes
    if (useSampleData) {
      return SampleAnnouncementData.generateSampleAnnouncements();
    }
    
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('isPublished', isEqualTo: true)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return AnnouncementModel.fromJson(data);
          })
          .toList();
    } catch (e) {
      print('Error fetching announcements: $e');
      // Fallback to sample data on error
      return SampleAnnouncementData.generateSampleAnnouncements();
    }
  }

  /// Create a new announcement
  static Future<void> createAnnouncement({
    required String title,
    required String message,
    required String createdBy,
    bool isPublished = true,
  }) async {
    try {
      await _firestore.collection(_collectionName).add({
        'title': title,
        'message': message,
        'createdBy': createdBy,
        'date': DateTime.now().toIso8601String(),
        'isPublished': isPublished,
      });
    } catch (e) {
      print('Error creating announcement: $e');
      rethrow;
    }
  }

  /// Update announcement
  static Future<void> updateAnnouncement(
    String id,
    Map<String, dynamic> updates,
  ) async {
    try {
      await _firestore.collection(_collectionName).doc(id).update(updates);
    } catch (e) {
      print('Error updating announcement: $e');
      rethrow;
    }
  }

  /// Delete announcement
  static Future<void> deleteAnnouncement(String id) async {
    try {
      await _firestore.collection(_collectionName).doc(id).delete();
    } catch (e) {
      print('Error deleting announcement: $e');
      rethrow;
    }
  }

  /// Stream announcements for real-time updates
  static Stream<List<AnnouncementModel>> streamPublishedAnnouncements() {
    return _firestore
        .collection(_collectionName)
        .where('isPublished', isEqualTo: true)
        .orderBy('date', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return AnnouncementModel.fromJson(data);
          })
          .toList();
    });
  }
}
