import 'package:bricd_up/constants/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyAcc extends StatefulWidget {
  const VerifyAcc({super.key});

  @override
  State<VerifyAcc> createState() => _VerifyAcc();
}

class _VerifyAcc extends State<VerifyAcc> {

  final User? user = FirebaseAuth.instance.currentUser;

  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: user!.email);
  }

  @override
  Widget build(BuildContext context) {
    if (user != null) {

      if ( (user!.emailVerified) ) {
        // send them to home
      }

      return Scaffold(
        backgroundColor: AppColors.primaryGreen,
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 450,
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Enter your email',

                    ),
                  ),
                )
              ],
            )
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: AppColors.primaryGreen,
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('User is not logged in.'),
              ],
            ),
          ),
        ),
      );
    }
  }
}