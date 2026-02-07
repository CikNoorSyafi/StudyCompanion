import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 🔥 Get all chats for current parent
  static Stream<QuerySnapshot> getParentChats() {
    final parentUid = _auth.currentUser!.uid;

    return _db
        .collection('chats')
        .where('parentUid', isEqualTo: parentUid)
        .orderBy('lastUpdated', descending: true)
        .snapshots();
  }

  /// 🔥 Get messages inside one chat
  static Stream<QuerySnapshot> getChatMessages(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
  }

  /// 🔥 Send message
  static Future<void> sendMessage(
    String chatId,
    String text,
    String senderRole,
  ) async {
    final messageRef = _db
        .collection('chats')
        .doc(chatId)
        .collection('messages');

    await messageRef.add({
      'text': text,
      'sender': senderRole,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await _db.collection('chats').doc(chatId).update({
      'lastMessage': text,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }
}
