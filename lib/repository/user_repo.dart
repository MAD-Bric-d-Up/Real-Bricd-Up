import 'package:bricd_up/models/friend_model.dart';
import 'package:bricd_up/models/search_model.dart';
import 'package:bricd_up/models/user_profile.dart';
import 'package:bricd_up/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepo {

  static final UserRepo instance = UserRepo._internal();

  UserRepo._internal();

  // Retrieves the current User via uid
  Future<UserProfile?> fetchUserProfile() async {
    final User? authUser = FirebaseAuth.instance.currentUser;

    if (authUser == null) {
      return null;
    }

    final String uid = authUser.uid;

    try {
      final Map<String, dynamic>? rawData = await UserRepo.instance.getUserData(uid);

      if (rawData != null) {
        rawData['email'] = authUser.email;
        return UserProfile.fromMap(uid, rawData);
      } else {
        return null;
      }

    } catch (e) {
      print("Error fetching user profile: $e");
      return null;
    }
  }

  // Retrieves a User via username
  Future<UserProfile?> fetchUserProfileByUsername(String username) async {
    try {
      final Map<String, dynamic>? rawData = await FirestoreService.instance.getUserDataByUsername(username);

      if (rawData == null) {
        return null;
      }

      final String? uid = rawData['uid'] as String?;

      if (uid == null) {
        return null;
      }

      return UserProfile.fromMap(uid, rawData);
    } catch (e) {
      print('Error in userrepo fetchuserprofilebyusername: $e');
      return null;
    }
  }

  Future<UserProfile?> fetchUserProfileByUid(String uid) async {
    try {
      final Map<String, dynamic>? rawData = await FirestoreService.instance.getUserDataByUid(uid);
      if  (rawData == null) {
        return null;
      }

      return UserProfile.fromMap(uid, rawData);
    } catch (e) {
      print('error in userrepo fetchuser by uid: $e');
      return null;
    }
  }

  // Creates a User
  Future<void> createUserDatabaseEntry(String uid, String email, String username) async {
    FirestoreService.instance.createUserDatabaseEntry(uid, email, username);
  }

  // ts method interacts with FirestoreService and handles return type
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final FirestoreService _db = FirestoreService.instance;
    return await _db.getUserData(uid);
  }

  // Retrieves user 
  Future<List<FriendModel>> getFriendsList(String userUid) async {
    final QuerySnapshot snapshot = await FirestoreService.instance.getSubcollection('users', userUid, 'friends');
    return snapshot.docs.map((doc) {
      return FriendModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }

  // Counts user's friends
  Future<int> countUserFriends(String userUid) async {
    try {
      final QuerySnapshot snapshot = await FirestoreService.instance.countFriends(userUid);
      return snapshot.size;
    } catch (e) {
      print('error counting friends: $e');
      return 71005;
    }
  }

  Future<List<SearchModel>> getUserPastSearches(String userUid) async {
    try {
      final QuerySnapshot snapshot = await FirestoreService.instance.getPastSearches(userUid);

      final Set<String> distinctSearches = {};
      final List<DocumentSnapshot> distinctDocs = [];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        if (data.containsKey('searchContent') && data['searchContent'] is String) {
          final content = data['searchContent'] as String;

          if (distinctSearches.add(content)) {
            distinctDocs.add(doc);
          }
        }
      }

      List<SearchModel> bullshit =  distinctDocs.map((doc) {
        final docId = doc.id;
        final dataMap = doc.data() as Map<String, dynamic>;
        return SearchModel.fromMap(docId, dataMap);
      }).toList();

      while (bullshit.length > 3) {
        bullshit.removeLast();
      }

      return bullshit;
    } catch (e) {
      print('error in user repo getting past searches $e');
      return [];
    }
  }
}