import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// authentication kayıt giriş işlemleri

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> registerWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Firebase hata kodlarına göre özel mesaj döndürüyoruz
      throw e;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'unknown',
        message: 'Bilinmeyen bir hata oluştu.',
      );
    }
  }

  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _setLoginState(true);
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Hata üst metoda iletilecek, ekran gösterecek
      throw e;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'unknown',
        message: 'Bilinmeyen bir hata oluştu.',
      );
    }
  }


  Future<void> signOut() async {
    await _auth.signOut();
    await _setLoginState(false);
  }

  Future<void> _setLoginState(bool state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', state);
  }
}
