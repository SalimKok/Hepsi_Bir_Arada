
import 'package:flutter/material.dart';
import 'package:hesapyonetim/screens/home_screen.dart';
import 'package:hesapyonetim/screens/register_screen.dart';
import 'package:hesapyonetim/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  void _login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    //  Boş alan kontrolü
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("E-posta ve şifre boş bırakılamaz.")),
      );
      return;
    }

    try {
      final user = await _authService.loginWithEmail(email, password);

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Geçersiz e-posta adresi.';
          break;
        case 'invalid-credential':
          errorMessage = 'Şifre veya e-posta yanlış.';
          break;
        default:
          errorMessage = 'Bir hata oluştu: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      // Diğer beklenmeyen hatalar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bilinmeyen bir hata oluştu.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Giriş Yap"),centerTitle: true,backgroundColor:Color.fromARGB(255, 245, 245, 220) ,),
      body: Container(color: const Color.fromARGB(255, 245, 245, 220),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
               const CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('assets/images/logo.png'),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(height: 20,),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Şifre",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(height: 50,width: 150,
                child: ElevatedButton(
                  onPressed: () => _login(context),
                  child: const Text("Giriş Yap", style: TextStyle(fontSize: 18,color: Colors.black),),

                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterScreen()),
                  );
                },
                child: const Text("Hesabınız yok mu? Kayıt olun",style: TextStyle(fontSize: 16,color: Colors.black),),
              )
            ],
          ),
        ),
      ),
    );
  }
}

