import 'package:bricd_up/models/user_profile.dart';

class FriendRequestStatus {
  final bool isRequestSent;
  final UserProfile? recipientProfile;

  FriendRequestStatus({required this.isRequestSent, required this.recipientProfile});
}