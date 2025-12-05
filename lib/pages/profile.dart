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
        final int? friendCount = user?.friendCount;
        
        return Scaffold(
          backgroundColor: AppColors.primaryGreen,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 500,
                    maxHeight: 150,
                  ),
                  child: Card (
                    color: Colors.white,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding (
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // profile picture
                          Container(
                            width: 125.0,
                            height: 125.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryGreen,
                              border: Border.all(
                                color: Colors.black,
                                width: 5.0,
                              )
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // username and shi
                                Text(
                                  usernameText!,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black
                                  ),
                                ),

                                Text(
                                  emailText!,
                                  style: const TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Text(
                                    "Friends: " + friendCount!.toString(),
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                    "Posts: 0", // + postCount
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 500,
                    maxHeight: 800,
                  ),
                  child: Card (
                    color: Colors.white,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding (
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // posts will go here
                          Text(
                            "<Posts will appear here>",
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          )
        );
      } // builder
    );
  }
}