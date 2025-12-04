import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchModel extends ChangeNotifier {
  final String uid;
  final String searcherUid;
  final String searcherUsername;
  final String searchContent;
  final DateTime createdAt;

  SearchModel({
    required this.uid,
    required this.searcherUid,
    required this.searcherUsername,
    required this.searchContent,
    required this.createdAt,
  });

  factory SearchModel.fromMap(String uid, Map<String, dynamic> data) {
    return SearchModel(
      uid: uid,
      searcherUid: data['userUid'] as String? ?? '',
      searcherUsername: data['username'] as String? ?? '',
      searchContent: data['searchContent'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'searcherUid': searcherUid,
      'searcherUsername': searcherUsername,
      'searchContent': searchContent,
      'createdAt': createdAt,
    };
  }
}