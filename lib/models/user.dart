import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProfile extends ChangeNotifier {
  final String uid;
  final String email;
  final String username;
  final DateTime createdAt;

  UserProfile({
    required this.uid,
    required this.email,
    required this.username,
    required this.createdAt,
  });

  factory UserProfile.fromMap(Map<String, dynamic> data) {
    return UserProfile(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
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