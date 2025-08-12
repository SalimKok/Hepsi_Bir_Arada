import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendReplyToBackend(
  String replyText,
  String sender,
  String commentId,
  String messageNo,
  String messageId,
  String object,
  String userid,
) async {
  final url = Uri.parse('http://10.0.2.2:5000/api/send_reply');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'reply': replyText,
        'sender': sender,
        'comment_id': commentId,
        'message_no': messageNo,
        'message_id': messageId,
        'object': object,
        'userid': userid,
      }),
    );

    if (response.statusCode == 200) {
      print('✅ Yanıt başarıyla gönderildi!');
    } else {
      print('❌ Hata: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print('🛑 Gönderme hatası: $e');
  }
}
