import 'package:bricd_up/components/appbar.dart';
import 'package:bricd_up/components/navbar.dart';
import 'package:bricd_up/constants/app_colors.dart';
import 'package:bricd_up/models/friend_request_status.dart';
import 'package:bricd_up/models/user_profile.dart';
import 'package:bricd_up/repository/friend_request_repo.dart';
import 'package:bricd_up/repository/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OtherProfile extends StatefulWidget {
  final UserProfile userProfile;

  const OtherProfile({
    super.key,
    required this.userProfile,
  });

  @override
  State<OtherProfile> createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {

  late Future<FriendRequestStatus> _friendRequestStatus;

  @override
  void initState() {
    super.initState();
    _friendRequestStatus = _checkIfFriendRequestSent();
  }

  Future<FriendRequestStatus> _checkIfFriendRequestSent() async {
    final User? sender = FirebaseAuth.instance.currentUser;
    final String targetUsername = widget.userProfile.username;

    final UserProfile? recipientData = await UserRepo.instance.fetchUserProfileByUsername(targetUsername);

    if (recipientData == null || sender == null) {
      return FriendRequestStatus(isRequestSent: false, recipientProfile: recipientData);
    }

    bool isSent = await FriendRequestRepo.instance.checkIfFriendRequestExists(sender.uid, recipientData.uid);

    return FriendRequestStatus(isRequestSent: isSent, recipientProfile: recipientData);
  }


  @override
  Widget build(BuildContext context) {
    final String usernameText = widget.userProfile.username;
    final int friendCount = widget.userProfile.friendCount;
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: AppColors.primaryGreen,
      //bottomNavigationBar: Navbar(tabController: widget.tabController),
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
                              usernameText,
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w800,
                                color: Colors.black
                              ),
                            ),
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
                            const SizedBox(height: 10),
                            // friend button
                            FutureBuilder<FriendRequestStatus>(
                              future: _friendRequestStatus,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                if (snapshot.hasError) {
                                  return const CircularProgressIndicator();
                                }

                                if (snapshot.hasData) {
                                  final FriendRequestStatus data = snapshot.data!;

                                  return FriendRequestButton(
                                    recipientProfile: data.recipientProfile,
                                    initialIsSent: data.isRequestSent
                                  );
                                }
                                return SizedBox.shrink();
                              },
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
      ),
    );
  }
}

class FriendRequestButton extends StatefulWidget {
  final UserProfile? recipientProfile;
  final bool initialIsSent;

  const FriendRequestButton({
    super.key,
    required this.recipientProfile,
    required this.initialIsSent,
  });

  @override
  State<FriendRequestButton> createState() => _FriendRequestButton();
}

class _FriendRequestButton extends State<FriendRequestButton> {
  late bool _isRequestPending;

  late String _recipientUid;
  late String _senderUid;

  @override
  void initState() {
    super.initState();
    _isRequestPending = widget.initialIsSent;
    _recipientUid = widget.recipientProfile!.uid;
    _senderUid = FirebaseAuth.instance.currentUser!.uid;
  }

  Future<void> _toggleFriendRequests() async {
    final bool sending = !_isRequestPending;

    setState(() {
      _isRequestPending = sending;
    });

    try {
      if (sending) {
        await FriendRequestRepo.instance.sendFriendRequest(widget.recipientProfile!.username);
      } else {
        await FriendRequestRepo.instance.removeFriendRequest(_senderUid, _recipientUid);
      }
    } catch (e) {
      setState(() {
        _isRequestPending = !sending;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: _toggleFriendRequests,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(40.0),
          backgroundColor: AppColors.navbarGold
        ),
        child: Text(
          _isRequestPending
          ? 'Remove Friend Request'
          : 'Send Friend Request',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600
          ),
        ),
      ),
    );
  }
}