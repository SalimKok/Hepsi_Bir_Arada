import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookLoginPage extends StatefulWidget {
  @override
  _FacebookLoginPageState createState() => _FacebookLoginPageState();
}

class _FacebookLoginPageState extends State<FacebookLoginPage> {
  Map<String, dynamic>? _userData;

  Future<void> _loginWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: ['email', 'public_profile'],
    );

    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData();
      setState(() {
        _userData = userData;
      });
    } else {
      print(result.status);
      print(result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Facebook Login")),
      body: Center(
        child:
            _userData != null
                ? Text("Merhaba, ${_userData!['name']}")
                : ElevatedButton(
                  onPressed: _loginWithFacebook,
                  child: Text("Facebook ile Giriş Yap"),
                ),
      ),
    );
  }
}
