// This file contains the ParentService class which interacts with Firebase
// to fetch data related to children associated with a parent user.
// It retrieves children's details along with their subject performances.
// The service uses Firebase Authentication to identify the current parent user
// and Firestore to query the relevant data.
// Make sure to add error handling and optimizations as needed for production use.
// Note: This code assumes that the Firestore structure includes a 'children'
// collection where each child document contains a 'parentUid' field and a
// 'subjects' subcollection for subject performance data.

import '../models/child_model.dart';
import '../models/subject_performance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ParentService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // ---------------- GET CHILDREN ----------------
  static Future<List<ChildModel>> getChildren() async {
    final parentUid = _auth.currentUser?.uid;

    if (parentUid == null) return [];

    final query = await _db
        .collection('children')
        .where('parentUids', arrayContains: parentUid)
        .get();

    return Future.wait(
      query.docs.map((doc) async {
        final data = doc.data();

        final subjectSnapshot = await _db
            .collection('children')
            .doc(doc.id)
            .collection('subjects')
            .get();

        final subjects = subjectSnapshot.docs.map((subjectDoc) {
          final subjectData = subjectDoc.data();
          return SubjectPerformance(
            subjectName: subjectData['subjectName'] ?? '',
            score: subjectData['score'] ?? 0,
          );
        }).toList();

        double overallAverage = 0;

        if (subjects.isNotEmpty) {
          overallAverage =
              subjects.map((s) => s.score).reduce((a, b) => a + b) /
              subjects.length;
        }

        return ChildModel(
          id: doc.id,
          name: data['name'] ?? '',
          grade: data['form'] ?? '',
          overallAverage: overallAverage,
          homework: data['homework'] ?? '',
          quiz: data['quiz'] ?? '',
          reminder: data['reminder'] ?? '',
          subjects: subjects,
          attendance: data['attendance'] ?? 0,
          teacherRemark: data['teacherRemark'] ?? '',
        );
      }),
    );
  }

  // ---------------- LINK CHILD ----------------
  static Future<String> linkChild(String linkingCode) async {
    final parentUid = _auth.currentUser?.uid;

    if (parentUid == null) return "User not logged in";

    final query = await _db
        .collection('children')
        .where('linkingCode', isEqualTo: linkingCode)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      return "Invalid linking code";
    }

    final childDoc = query.docs.first;

    await _db.collection('children').doc(childDoc.id).update({
      'parentUids': FieldValue.arrayUnion([parentUid]),
    });

    return "Child linked successfully";
  }
}
