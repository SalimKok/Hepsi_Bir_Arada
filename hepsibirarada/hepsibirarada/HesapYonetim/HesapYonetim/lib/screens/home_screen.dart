import 'package:flutter/material.dart';
import 'package:hesapyonetim/screens/login_screen.dart';
import 'package:hesapyonetim/services/auth_service.dart';
import 'package:hesapyonetim/services/callProtectedAPI.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> sendMessage() async {
  final url = Uri.parse('http://10.0.2.2:5000/api/messages');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': 'kullanici_nur',
        'platform': 'instagram',
        'message': 'Merhaba! Bu mesaj Flask backend’e gidiyor.'
      }),
    );

    print('Durum: ${response.statusCode}');
    print('Cevap: ${response.body}');
  } catch (e) {
    print('Hata oluştu: $e');
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) async {
    final authService = AuthService();
    await authService.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ana Sayfa")),
      body: Center(
        child: Column(
            children: [ElevatedButton(
          onPressed: () => _logout(context),
          child: const Text("Çıkış Yap"),
        ),

          ElevatedButton(
            onPressed: () {
              //sendMessage();
              fetchProtectedData();
            },
            child: Text('Mesaj Gönder'),
          ),
    ],
        ),
      ),
    );
  }
}
