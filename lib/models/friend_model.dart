import 'package:cloud_firestore/cloud_firestore.dart';

class FriendModel {
  final String friendUid;
  final String status;
  final DateTime friendedAt;

  const FriendModel({
    required this.friendUid,
    required this.status,
    required this.friendedAt,
  });

  factory FriendModel.fromMap(String friendUid, Map<String, dynamic> data) {
    return FriendModel(
      friendUid: friendUid,
      status: data['status'] as String? ?? '',
      friendedAt: (data['friendedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'friendUid': friendUid,
      'status': status,
      'friendedAt': friendedAt
    };
  }
}