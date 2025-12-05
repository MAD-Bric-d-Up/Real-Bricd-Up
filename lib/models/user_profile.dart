import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProfile extends ChangeNotifier {
  final String uid;
  final String email;
  final String username;
  final DateTime createdAt;
  final int friendCount;

  UserProfile({
    required this.uid,
    required this.email,
    required this.username,
    required this.createdAt,
    required this.friendCount,
  });

  factory UserProfile.fromMap(String uid, Map<String, dynamic> data, int friendCount) {
    return UserProfile(
      uid: uid,
      email: data['email'] as String? ?? '',
      username: data['username'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      friendCount: friendCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

}