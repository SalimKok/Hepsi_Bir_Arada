import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> sendUserIdToWebhook() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('user_id'); // ID'yi al

  if (userId != null) {
    final url = Uri.parse('http://10.0.2.2:5000/webhook');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId}),
    );

    if (response.statusCode == 200) {
      print('User ID sent successfully');
    } else {
      print('Failed to send User ID');
    }
  } else {
    print('No user ID found in SharedPreferences');
  }
}
