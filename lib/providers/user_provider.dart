import 'package:bricd_up/models/user_profile.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserProfile? _userProfile;

  UserProfile? get userProfile => _userProfile;

  void setUserProfile(UserProfile profile) {
    _userProfile = profile;
    notifyListeners();
  }
}