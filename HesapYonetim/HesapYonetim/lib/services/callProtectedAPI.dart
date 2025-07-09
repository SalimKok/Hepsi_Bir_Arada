import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

Future<String?> getToken() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return await user.getIdToken();
  }
  return null;
}

Future<void> fetchProtectedData() async {
  final token = await getToken();

  if (token == null) {
    print("Giriş yapılmamış.");
    return;
  }

  final response = await http.get(
    Uri.parse('http://10.0.2.2:5000/protected-data'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print("Başarılı: ${response.body}");
  } else {
    print("Hata: ${response.statusCode} - ${response.body}");
  }
}

//firebase ile giriş yapmış kullanıcının kimliğini doğrulayarak,
// backend API'sinden özel veri çekmek.