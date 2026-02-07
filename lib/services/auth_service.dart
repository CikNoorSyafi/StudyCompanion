import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ================= REGISTER =================
  static Future<String> register(UserModel user) async {
    try {
      // 1️⃣ Create account in Firebase Auth
      final cred = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      // 2️⃣ Save extra data in Firestore
      await _db.collection('users').doc(cred.user!.uid).set({
        "name": user.name,
        "email": user.email,
        "role": user.role,
        "school": user.school,
        "linkingCode": user.linkingCode,
      });

      return "Registration successful";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Registration failed";
    }
  }

  // ================= LOGIN =================
  static Future<String> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Login successful";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Login failed";
    }
  }

  // ================= GET USER DATA =================
  static Future<Map<String, dynamic>?> getUserData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final doc = await _db.collection('users').doc(uid).get();
    return doc.data();
  }
}
