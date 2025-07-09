import 'package:flutter/material.dart';
import 'package:hesapyonetim/screens/login_screen.dart';
import 'package:hesapyonetim/services/auth_service.dart';

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
        child: ElevatedButton(
          onPressed: () => _logout(context),
          child: const Text("Çıkış Yap"),
        ),
      ),
    );
  }
}
