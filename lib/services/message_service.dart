import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

class MessageService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'messages';

  /// Get all messages
  static Future<List<MessageModel>> getMessages() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .orderBy('time', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return MessageModel.fromJson(data);
          })
          .toList();
    } catch (e) {
      print('Error fetching messages: $e');
      return [];
    }
  }

  /// Stream messages for real-time updates
  static Stream<List<MessageModel>> streamMessages() {
    return _firestore
        .collection(_collectionName)
        .orderBy('time', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return MessageModel.fromJson(data);
          })
          .toList();
    });
  }

  /// Create new chat/message thread
  static Future<MessageModel> createNewChat({
    required String teacherName,
    required String studentName,
  }) async {
    try {
      final newMessage = MessageModel(
        id: '',
        teacherName: teacherName,
        studentName: studentName,
        lastMessage: '',
        time: 'Now',
        unread: false,
        messages: [],
      );

      final docRef = await _firestore
          .collection(_collectionName)
          .add(newMessage.toJson());

      newMessage.id == docRef.id;
      return newMessage;
    } catch (e) {
      print('Error creating new chat: $e');
      rethrow;
    }
  }

  /// Add a message to a chat thread
  static Future<void> addMessageToChat(
    String chatId,
    ChatMessage message,
  ) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(chatId).get();
      final currentMessages = (doc.data()?['messages'] as List? ?? [])
          .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
          .toList();

      currentMessages.add(message);

      await _firestore.collection(_collectionName).doc(chatId).update({
        'messages': currentMessages.map((m) => m.toJson()).toList(),
        'lastMessage': message.text,
        'time': DateTime.now().toString(),
      });
    } catch (e) {
      print('Error adding message to chat: $e');
      rethrow;
    }
  }

  /// Get specific chat thread
  static Future<MessageModel?> getChatById(String chatId) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(chatId).get();
      if (doc.exists) {
        final data = doc.data() ?? {};
        data['id'] = doc.id;
        return MessageModel.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error getting chat: $e');
      return null;
    }
  }

  /// Delete a message thread
  static Future<void> deleteChatThread(String chatId) async {
    try {
      await _firestore.collection(_collectionName).doc(chatId).delete();
    } catch (e) {
      print('Error deleting chat thread: $e');
      rethrow;
    }
  }
}
