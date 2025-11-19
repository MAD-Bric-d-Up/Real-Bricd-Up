import 'package:bricd_up/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

Future<UserProfile?> fetchUserProfile() async {
  final User? authUser = FirebaseAuth.instance.currentUser;

  if (authUser == null) {
    return null;
  }

  final String uid = authUser.uid;
  final DatabaseReference userRef = FirebaseDatabase.instance.ref('users').child(uid);

  try {
    final DataSnapshot snapshot = await userRef.get();

    if (snapshot.exists && snapshot.value is Map) {

      final rawMap = snapshot.value as Map;

      final Map<String, dynamic> userDataMap = {};

      rawMap.forEach((key, value) {
        userDataMap[key.toString()] = value;
      });

      userDataMap['email'] = authUser.email;

      return UserProfile.fromMap(uid, userDataMap);
    } else {
      print("User node exists, but no valid map data found.");
      return null;
    }
  } catch (e) {
    print("Error fetching user profile: $e");
    return null;
  }
}