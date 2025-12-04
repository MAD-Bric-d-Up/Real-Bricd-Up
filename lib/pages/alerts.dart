import 'package:bricd_up/constants/app_colors.dart';
import 'package:bricd_up/models/friend_request_model.dart';
import 'package:bricd_up/models/user_profile.dart';
import 'package:bricd_up/repository/friend_request_repo.dart';
import 'package:bricd_up/repository/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Alerts extends StatefulWidget {
  const Alerts({super.key});

  @override
  State<Alerts> createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {


  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    final String username = user?.displayName ?? "there's a fucking bug here dumbass";
    
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBeige,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_left)
        ),
        title: Text(
          username,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 30.0,
            color: AppColors.primaryGreen,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<FriendRequestModel>>(
        future: FriendRequestRepo.instance.getAllFriendRequestNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: CircularProgressIndicator());
          }

          if(snapshot.hasData) {
            final List<FriendRequestModel> requests = snapshot.data!;

            if (requests.isEmpty) {
              return const Center(child: Text(
                'No pending friend requests...',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0,
                  color: Colors.white
                ),
              ));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: requests.map((req) {
                  return _buildRequestBlock(context, req);
                }).toList()
              ),
            );
          }

          return const Center(child: Text('Start fetching data...'));
        },
      )
    );
  }

  Widget _buildRequestBlock(BuildContext context, FriendRequestModel request) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border: Border.symmetric(horizontal: BorderSide(
              color: Colors.black87,
              width: 1.5,
            )
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: UserRepo.instance.fetchUserProfileByUid(request.senderUid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(
                          'Loading sender',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return const Text('User Fetch Error');
                      }

                      final String senderUid = request.senderUid;
                      final String senderUsername = snapshot.data!.username;
                      final String alertText = 'Incoming request from @$senderUsername';

                      

                      return Row(
                        children: [
                          Text(
                            alertText,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),

                          const Spacer(),

                          ElevatedButton(
                            onPressed: () async {
                              final String recipientUid = FirebaseAuth.instance.currentUser!.uid;
                              await FriendRequestRepo.instance.acceptFriendRequest(request.uid, senderUid, recipientUid);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 35),
                              maximumSize: const Size(100, 35),
                              backgroundColor: AppColors.navbarGold,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              side: const BorderSide(
                                color: Colors.black,
                                width: 1.0
                              )
                            ),
                            child: Text(
                              'Accept',
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}