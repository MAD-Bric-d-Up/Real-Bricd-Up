import 'package:bricd_up/models/friend_request_model.dart';
import 'package:bricd_up/models/user_profile.dart';
import 'package:bricd_up/repository/user_repo.dart';
import 'package:bricd_up/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendRequestRepo {
  static final FriendRequestRepo instance = FriendRequestRepo._internal();

  FriendRequestRepo._internal();

  Future<String> sendFriendRequest(String recipientUsername) async {
    final User? sender = FirebaseAuth.instance.currentUser;

    if (sender == null) return 'sender null';

    final String senderUid = sender.uid;

    final UserProfile? recipientData = await UserRepo.instance.fetchUserProfileByUsername(recipientUsername);

    if (recipientData == null) return 'recipient null';

    final String recipientUid = recipientData.uid;

    final Map<String, dynamic> requestData = {
      'senderUid': senderUid,
      'recipientUid': recipientUid,
      'status': 'pending',
      'createdAt': Timestamp.now()
    };

    try {
      final bool reqExists = await FirestoreService.instance.checkFriendRequestIfExists(senderUid, recipientUid);
      if (reqExists) {
        return 'Resource already exists';
      } else {
        await FirestoreService.instance.createFriendRequestEntry(requestData);
        return 'Resource created';
      }

    } catch(e) {
      print('Error sending friend request: $e');
      return 'Error';
    }
  }

  Future<void> acceptFriendRequest(String requestId, String senderUid, String recipientUid) async {
    final senderSubcollectionRef = FirebaseFirestore.instance.collection('users').doc(senderUid).collection('friends');
    final recipientSubcollectionRef = FirebaseFirestore.instance.collection('users').doc(recipientUid).collection('friends');
    final requestDocRef = FirebaseFirestore.instance.collection('friend_requests').doc(requestId);

    final Map<String, dynamic> friendData = {
      'status': 'active',
      'friendedAt': Timestamp.now()
    };

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(senderSubcollectionRef.doc(recipientUid), friendData);
        transaction.set(recipientSubcollectionRef.doc(senderUid), friendData);
        transaction.delete(requestDocRef);
      });
    } catch (e) {
      print('error accepting friend request: $e');
      return;
    }
  }

  Future<List<FriendRequestModel>> getAllFriendRequestNotifications() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];
    final String uid = user.uid;
    try {
      final QuerySnapshot snapshot = await FirestoreService.instance.getFriendRequests(uid);
      return snapshot.docs.map((doc) {
        return FriendRequestModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('error retrieving all friend requests: $e');
      return [];
    }
  }

  Future<bool> checkIfFriendRequestExists(String senderUid, String recipientUid) async {
    try {
      return FirestoreService.instance.checkFriendRequestIfExists(senderUid, recipientUid);
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFriendRequest(String senderUid, String recipientUid) async {
    try {
      return await FirestoreService.instance.deleteFriendRequest(senderUid, recipientUid);
    } catch (e) {
      print('error deleting the friend reqeust: $e');
      return false;
    }
  }
}