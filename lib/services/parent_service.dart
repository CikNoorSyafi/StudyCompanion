import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studycompanion_app/models/child_model.dart';
import 'package:studycompanion_app/models/subject_performance.dart';

class ParentService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _childrenCollection = 'children';
  static const String _subjectsCollection = 'subjects';

  /// Get children for a parent
  static Future<List<ChildModel>> getChildren({
    String? parentId,
  }) async {
    try {
      Query query = _firestore.collection(_childrenCollection);

      // If parentId is provided, filter by it
      if (parentId != null) {
        query = query.where('parentId', isEqualTo: parentId);
      }

      final querySnapshot = await query.get();

      final children = <ChildModel>[];

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;

        // Get subjects for this child
        final subjectsSnapshot = await _firestore
            .collection(_childrenCollection)
            .doc(doc.id)
            .collection(_subjectsCollection)
            .get();

        final subjects = subjectsSnapshot.docs
            .map((subjectDoc) =>
                SubjectPerformance.fromJson(subjectDoc.data()))
            .toList();

        data['subjects'] = subjects;

        children.add(ChildModel.fromJson(data));
      }

      return children;
    } catch (e) {
      print('Error fetching children: $e');
      return [];
    }
  }

  /// Stream children for real-time updates
  static Stream<List<ChildModel>> streamChildren({String? parentId}) {
    Query query = _firestore.collection(_childrenCollection);

    if (parentId != null) {
      query = query.where('parentId', isEqualTo: parentId);
    }

    return query.snapshots().asyncMap((querySnapshot) async {
      final children = <ChildModel>[];

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;

        // Get subjects for this child
        final subjectsSnapshot = await _firestore
            .collection(_childrenCollection)
            .doc(doc.id)
            .collection(_subjectsCollection)
            .get();

        final subjects = subjectsSnapshot.docs
            .map((subjectDoc) =>
                SubjectPerformance.fromJson(subjectDoc.data()))
            .toList();

        data['subjects'] = subjects;

        children.add(ChildModel.fromJson(data));
      }

      return children;
    });
  }

  /// Get a specific child by ID
  static Future<ChildModel?> getChildById(String childId) async {
    try {
      final doc =
          await _firestore.collection(_childrenCollection).doc(childId).get();

      if (doc.exists) {
        final data = doc.data() ?? {};
        data['id'] = doc.id;

        // Get subjects
        final subjectsSnapshot = await _firestore
            .collection(_childrenCollection)
            .doc(childId)
            .collection(_subjectsCollection)
            .get();

        final subjects = subjectsSnapshot.docs
            .map((subjectDoc) =>
                SubjectPerformance.fromJson(subjectDoc.data()))
            .toList();

        data['subjects'] = subjects;

        return ChildModel.fromJson(data);
      }

      return null;
    } catch (e) {
      print('Error fetching child: $e');
      return null;
    }
  }

  /// Update child information
  static Future<void> updateChild(String childId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection(_childrenCollection).doc(childId).update(updates);
    } catch (e) {
      print('Error updating child: $e');
      rethrow;
    }
  }

  /// Update subject performance
  static Future<void> updateSubjectPerformance(
    String childId,
    String subjectName,
    int score,
  ) async {
    try {
      await _firestore
          .collection(_childrenCollection)
          .doc(childId)
          .collection(_subjectsCollection)
          .doc(subjectName)
          .set({
        'subjectName': subjectName,
        'score': score,
      });
    } catch (e) {
      print('Error updating subject performance: $e');
      rethrow;
    }
  }

  /// Get all parents in the system
  static List<Map<String, dynamic>> getAllParents() {
    return [
      {
        'id': 'p1',
        'name': 'Abdullah Hassan',
        'email': 'abdullah.hassan@school.edu.my',
        'phone': '+6012-3456789',
        'role': 'Parent',
        'status': 'Active',
        'childrenIds': ['s4'], // Siti Mariah
      },
      {
        'id': 'p2',
        'name': 'Encik Karim Ahmad',
        'email': 'karim.ahmad@school.edu.my',
        'phone': '+6012-1234567',
        'role': 'Parent',
        'status': 'Active',
        'childrenIds': ['s1'], // Amir Abdullah
      },
      {
        'id': 'p3',
        'name': 'Puan Norhaida Mahmud',
        'email': 'norhaida.mahmud@school.edu.my',
        'phone': '+6012-2345678',
        'role': 'Parent',
        'status': 'Active',
        'childrenIds': ['s2'], // Muhammad Azhar
      },
      {
        'id': 'p4',
        'name': 'Encik Lim Chen Hao',
        'email': 'lim.chenhao@school.edu.my',
        'phone': '+6012-3456701',
        'role': 'Parent',
        'status': 'Active',
        'childrenIds': ['s5'], // Lim Wei Chen
      },
      {
        'id': 'p5',
        'name': 'Mr. Raj Nair Kumar',
        'email': 'raj.nair@school.edu.my',
        'phone': '+6012-4567812',
        'role': 'Parent',
        'status': 'Active',
        'childrenIds': ['s6'], // Raj Kumar
      },
      {
        'id': 'p6',
        'name': 'Encik Wong Tian Huat',
        'email': 'wong.tianhuat@school.edu.my',
        'phone': '+6012-5678923',
        'role': 'Parent',
        'status': 'Active',
        'childrenIds': ['s7'], // Sophia Wong
      },
      {
        'id': 'p7',
        'name': 'Mr. Viswanathan Sharma',
        'email': 'viswanathan.sharma@school.edu.my',
        'phone': '+6012-6789034',
        'role': 'Parent',
        'status': 'Active',
        'childrenIds': ['s8'], // Priya Sharma
      },
      {
        'id': 'p8',
        'name': 'Puan Siti Nur Azizah',
        'email': 'siti.azizah@school.edu.my',
        'phone': '+6012-7890145',
        'role': 'Parent',
        'status': 'Active',
        'childrenIds': ['s3', 's11'], // Nur Azlina, Nurul Izzah
      },
      {
        'id': 'p9',
        'name': 'Encik Ooi Seng Keat',
        'email': 'ooi.sengkeat@school.edu.my',
        'phone': '+6012-8901256',
        'role': 'Parent',
        'status': 'Active',
        'childrenIds': ['s12'], // Davina Ooi
      },
      {
        'id': 'p10',
        'name': 'Encik Tan Cheng Huat',
        'email': 'tan.chenhuat@school.edu.my',
        'phone': '+6012-9012367',
        'role': 'Parent',
        'status': 'Active',
        'childrenIds': ['s10'], // Tan Jun Wei
      },
      {
        'id': 'p11',
        'name': 'Encik Rashid Abdullah',
        'email': 'rashid.abdullah@school.edu.my',
        'phone': '+6012-0123478',
        'role': 'Parent',
        'status': 'Active',
        'childrenIds': ['s9'], // Adnan Hassan
      },
    ];
  }

  /// Get parent by ID
  static Map<String, dynamic>? getParentById(String parentId) {
    try {
      return getAllParents().firstWhere((parent) => parent['id'] == parentId);
    } catch (e) {
      return null;
    }
  }

  /// Get parent count
  static int getParentCount() {
    return getAllParents().length;
  }
}
