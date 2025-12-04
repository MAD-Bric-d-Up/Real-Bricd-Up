import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final FirestoreService instance = FirestoreService._internal();

  FirestoreService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get reference to users collection
  CollectionReference get usersCollection => _firestore.collection('users');
  CollectionReference get searchesCollection => _firestore.collection('searches');
  CollectionReference get friendRequestsCollection => _firestore.collection('friend_requests');
  CollectionReference get imagesCollection => _firestore.collection('images');

  // retrieve single user document
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await usersCollection.doc(uid).get() as DocumentSnapshot<Map<String, dynamic>>;

      if (snapshot.exists) {
        return snapshot.data();
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // retrieve a single user document by username
  Future<Map<String, dynamic>?> getUserDataByUsername(String username) async {
    try {
      final QuerySnapshot snapshot = await usersCollection
        .where('username', isEqualTo: username)
        .limit(1)
        .get();

      if (snapshot.docs.isNotEmpty) {
        final DocumentSnapshot doc = snapshot.docs.first;
        final Map<String, dynamic>? userData = doc.data() as Map<String, dynamic>?;

        if (userData != null) {
          userData['uid'] = doc.id;
          return userData;
        }
      }
      return null;
    } catch (e) {
      print("Error fetching user by username: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserDataByUid(String uid) async {
    try {
      final QuerySnapshot snapshot = await usersCollection
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();

      if (snapshot.docs.isNotEmpty) {
        final DocumentSnapshot doc = snapshot.docs.first;
        final Map<String, dynamic>? userData = doc.data() as Map<String, dynamic>?;

        return userData;
      }
      return null;
    } catch (e) {
      print('error fetching user by uid: $e');
      return null;
    }
  }

  // add a single user document
  Future<void> createUserDatabaseEntry(String uid, String email, String username) async {
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'username': username,
      'createdAt': Timestamp.now(),
    });
  }

  // add a single search document
  Future<String> createSearchDatabaseEntry(Map<String, dynamic> postData) async {
    try {
      final DocumentReference newDocRef = await searchesCollection.add(postData);
      
      return newDocRef.id;
    } catch (e) {
      print('Error adding search document: $e');
      return "";
    }
  }

  Future<String> createFriendRequestEntry(Map<String, dynamic> postData) async {
    try {
      final DocumentReference newDocRef = await friendRequestsCollection.add(postData);
      return newDocRef.id;
    } catch (e) {
      print('Error adding friend request: $e');
      return "";
    }
  }

  Future<bool> checkFriendRequestIfExists(String senderUid, String recipientUid) async {
    try {
      final QuerySnapshot snapshot = await friendRequestsCollection
        .where('senderUid', isEqualTo: senderUid)
        .where('recipientUid', isEqualTo: recipientUid)
        .get();

      final QuerySnapshot snapshot2 = await friendRequestsCollection
        .where('recipientUid', isEqualTo: senderUid)
        .where('senderUid', isEqualTo: recipientUid)
        .get();

      return (snapshot.size > 0 || snapshot2.size > 0);
    } catch (e) {
      print('Error checking if friend request exists: $e');
      rethrow;
    }
  }

  Future<bool> deleteFriendRequest(String senderUid, String recipientUid) async {
    try {
      final QuerySnapshot snapshot = await friendRequestsCollection
        .where('senderUid', isEqualTo: senderUid)
        .where('recipientUid', isEqualTo: recipientUid)
        .get();

      if (snapshot.docs.isEmpty) {
        return false;
      }

      final DocumentSnapshot docToDelete = snapshot.docs.first;
      await docToDelete.reference.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<QuerySnapshot> getSubcollection(String parentCollection, String parentDocId, String subcollectionName) async {
    try {
      return await _firestore
        .collection(parentCollection)
        .doc(parentDocId)
        .collection(subcollectionName)
        .get();
    } catch (e) {
      print("Error fetching subcollection: $e");
      rethrow;
    }
  }

  Future<QuerySnapshot> countFriends(String userUid) async {
    try {
      final collectionRef = FirebaseFirestore.instance.collection('users').doc(userUid).collection('friends');
      return await collectionRef.get();
    } catch (e) {
      print('error retrieving friends to count: $e');
      rethrow;
    }
  }

  Future<QuerySnapshot> getFriendRequests(String userUid) async {
    try {
      return await friendRequestsCollection
        .where('recipientUid', isEqualTo: userUid)
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .get();
    } catch (e) {
      print('error retrieving friend requests for a user: $e');
      rethrow;
    }
  }

  Future<void> createImageDatabaseEntry(String uid, String imageURL) async {
    await _firestore
        .collection('images')
        .doc()
        .set({
          'uid': uid,
          'imageUrl': imageURL,
          'createdAt': Timestamp.now(),
        });
  }
}