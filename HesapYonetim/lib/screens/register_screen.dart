// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:hesapyonetim/services/auth_service.dart';
import 'home_screen.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  void _register(BuildContext context) async {
    final user = await _authService.registerWithEmail(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kayıt başarısız.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kayıt Ol")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: "Şifre")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _register(context),
              child: const Text("Kayıt Ol"),
            ),
          ],
        ),
      ),
    );
  }
}
