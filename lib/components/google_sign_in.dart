
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginButton extends StatelessWidget {
  GoogleLoginButton({super.key});

  static const List<String> scopes = <String>[
    'email',
  ];

  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate(
        scopeHint: scopes
      );

      if (googleUser != null) {
        // do something
      } else {
        // do something else
      }
    } catch (error) {
      print("bruh moment with login with google");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Image.asset(
        'lib/assets/google_logo_2.png',
        height: 40,
      ),
      label: const Text('Log In with Google'),
      onPressed: _handleSignIn,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }
}