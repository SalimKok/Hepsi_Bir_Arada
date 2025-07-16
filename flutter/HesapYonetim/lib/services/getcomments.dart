import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> getAllInstagramComments() async {
  final url = Uri.parse('http://10.0.2.2:5000/get-all-comments');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'accessToken': 'IGAAKeMpN0Gv1BZAFBnY0JqbkgtZAG1ZAUkE1S3A4VE1YRmVwWnBHTXB5ajk5ZAktDcW94MEl2QmdjRFVRWDBKMW9zZA19kSXBObVF3SDFMWC1wYUhMZAkNoNDVTaldmYXBtNHZA6b3VXYzF3WGI2MFdESTdWSXVmU1o5dVdKeUlPVEJ2awZDZD',
      }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final comments = data['comments'];
    print("Toplam yorum: ${comments.length}");

    for (var comment in comments) {
      print('${comment['username']} (${comment['caption']}): ${comment['text']}');
    }
  } else {
    print(' Hata: ${response.body}');
  }
}