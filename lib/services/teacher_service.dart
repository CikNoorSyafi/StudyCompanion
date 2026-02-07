import '../models/teacher_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeacherService {
  static Future<void> updateTodayFocus(
    String childId,
    String homework,
    String quiz,
    String reminder,
  ) async {
    await FirebaseFirestore.instance.collection('children').doc(childId).update(
      {
        'todayFocus': {
          'homework': homework,
          'quiz': quiz,
          'reminder': reminder,
          'updatedAt': FieldValue.serverTimestamp(),
        },
      },
    );
  }
}
