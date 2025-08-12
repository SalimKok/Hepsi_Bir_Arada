import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService {
  final CollectionReference _messageRef =
  FirebaseFirestore.instance.collection('instagram_messages');

  /// Mesajları timestamp'e göre sıralı şekilde getirir (anlık stream olarak)
  Stream<List<Map<String, dynamic>>> getMessages() {
    return _messageRef
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'sender': data['sender'] ?? 'Bilinmeyen',
          'text': data['text'] ?? '',
          'timestamp': data['timestamp'],
          'type': data['type'],
          'post_ıd': data['post_ıd'],
          'object': data['object'],
        };
      }).toList();
    });
  }
}
