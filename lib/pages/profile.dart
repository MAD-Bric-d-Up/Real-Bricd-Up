import 'package:bricd_up/constants/app_colors.dart';
import 'package:bricd_up/models/user_profile.dart';
import 'package:bricd_up/repository/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile?>(
      future: UserRepo.instance.fetchUserProfile(),
      builder: (context, snapshot) {

        final UserProfile? user = snapshot.data;
        final String? emailText = user?.email;
        final String? usernameText = user?.username;

        return Scaffold(
          backgroundColor: AppColors.primaryGreen,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                      emailText!,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                      ),
                    )
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      usernameText!,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black
                      ),
                    ),
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