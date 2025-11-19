import 'package:bricd_up/constants/app_colors.dart';
import 'package:bricd_up/models/user.dart';
import 'package:bricd_up/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final UserProfile currentUser = (FirebaseAuth.instance.currentUser).;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile>(
      future: fetchUserProfile(),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: AppColors.primaryGreen,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  // profile picture
                  Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                        width: 5.0,
                      )
                    ),
                  ),

                  // username and shi
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      currentUser?.username
                    )
                  )
                ],
              ),
            ),
          )
        );
      } // builder
    );
  }
}