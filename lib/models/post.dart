import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String imageURL;
  String username;
  final DateTime createdAt;
  String formattedTime;

  Post({
    required this.uid,
    required this.imageURL,
    required this.username,
    required this.createdAt,
    required this.formattedTime,
  });

  factory Post.fromMap(Map<String, dynamic> data, String docId) {
    final String uid = (data['uid'] as String?) ?? docId;

    final String imageURL = (data['imageURL'] as String?) ?? (data['imageUrl'] as String?) ?? '';

    final String username = (data['username'] as String?) ?? (data['userName'] as String?) ?? '';

    DateTime createdAt;
    if (data['createdAt'] is Timestamp) {
      createdAt = (data['createdAt'] as Timestamp).toDate();
    } else if (data['createdAt'] is int) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(data['createdAt'] as int);
    } else {
      createdAt = DateTime.now();
    }

    final String formattedTime = (data['formattedTime'] as String?) ?? '';

    return Post(
      uid: uid,
      imageURL: imageURL,
      username: username,
      createdAt: createdAt,
      formattedTime: formattedTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'imageURL': imageURL,
      'username': username,
      'createdAt': createdAt,
      'formattedTime': formattedTime,
    };
  }

  @override
  String toString() {
    return 'Post(uid: $uid, username: $username, imageURL: $imageURL, createdAt: $createdAt)';
  }

}