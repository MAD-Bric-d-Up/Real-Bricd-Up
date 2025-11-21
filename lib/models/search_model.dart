import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchModel extends ChangeNotifier {
  final String uid;
  final String userUid;
  final String username;
  final String searchContent;
  final DateTime createdAt;

  SearchModel({
    required this.uid,
    required this.userUid,
    required this.username,
    required this.searchContent,
    required this.createdAt,
  });

  factory SearchModel.fromMap(String uid, Map<String, dynamic> data) {
    return SearchModel(
      uid: uid,
      userUid: data['userUid'] as String? ?? '',
      username: data['username'] as String? ?? '',
      searchContent: data['searchContent'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userUid': userUid,
      'username': username,
      'searchContent': searchContent,
      'createdAt': createdAt,
    };
  }
}