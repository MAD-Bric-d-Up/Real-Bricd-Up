import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequestModel {
  final String uid;
  final String senderUid;
  final String recipientUid;
  final String status;
  final DateTime createdAt;

  const FriendRequestModel({
    required this.uid,
    required this.senderUid,
    required this.recipientUid,
    required this.status,
    required this.createdAt,
  });

  factory FriendRequestModel.fromMap(String uid, Map<String, dynamic> data) {
    return FriendRequestModel(
      uid: uid,
      senderUid: data['senderUid'] as String? ?? '',
      recipientUid: data['recipientUid'] as String? ?? '',
      status: data['status'] as String? ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'senderUid': senderUid,
      'recipientUid': recipientUid,
      'status': status,
      'createdAt': createdAt
    };
  }
}