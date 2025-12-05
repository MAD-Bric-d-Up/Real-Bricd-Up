import 'package:bricd_up/swipeable_pages.dart';
import 'package:bricd_up/components/google_sign_in.dart';
import 'package:bricd_up/constants/app_colors.dart';
import 'package:bricd_up/models/user_profile.dart';
import 'package:bricd_up/repository/user_repo.dart';
import 'package:bricd_up/pages/feed.dart';
import 'package:bricd_up/pages/register.dart';
import 'package:bricd_up/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  // Email and Password Text Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _passwordVisible = true;

  /// Good practice to dispose to prevent memory leaks
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffolds are basic visual structures that act as a foundation layout for a screen
    return Scaffold(
      backgroundColor: AppColors.primaryGreen, // body bg color

      // Main Body Content Here
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Bric'd Up",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // email Input
              SizedBox(
                width: 450,
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    prefixIcon: Icon(Icons.mail),
                    filled: true,
                    fillColor: AppColors.primaryBeige,
                  ),
                ),
              ),

              // spacer
              const SizedBox(height: 16.0),

              // Password Input
              SizedBox(
                width: 450,
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Enter Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    filled: true,
                    fillColor: AppColors.primaryBeige,
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      icon: Icon(
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      )
                    )
                  ),
                  obscureText: _passwordVisible,
                ),
              ),

              // spacer
              const SizedBox(height: 16.0),

              // Login Button
              SizedBox(
                width: 450,
                child: ElevatedButton(
                  onPressed: _handleLogin, 
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: AppColors.navbarGold,
                  ),
                  child: const Text('Login'),
                ),
              ),

              // Line Divider
              SizedBox(
                width: 450,
                child: const Divider(
                  color: Colors.black,
                  height: 40.0,
                  thickness: 1,
                ),
              ),

              // Google button
              SizedBox(
                width: 450,
                child: GoogleLoginButton(),
              ),

              GestureDetector(
                onTap: () => _navRegister(context),
                child: const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Click here to register!',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              )

            ],
          ),
        ) 
      ),
    );
  }

  Future<void> _handleLogin() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // perform input validation
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing username or password field.')),
      );
    } else {
      User? user = await _doLogin(email, password);

      if (user != null) {
        _onLoginSuccess(user);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error logging in.')),
        );
      }
    }
  }

  /// Performs login validation logic and calls backend 
  Future<User?> _doLogin(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );

      return userCredential.user;
    } on FirebaseAuthException catch (error) {
      print(error);
    }
  }

  void _onLoginSuccess(User user) async {

    Map<String, dynamic>? profileData = await _fetchUserProfileData(user.uid);

    if (profileData != null) {
      final int friendCount = await UserRepo.instance.countUserFriends(user.uid);
      final UserProfile userProfile = UserProfile.fromMap(user.uid, profileData, friendCount);

      final model = Provider.of<UserProvider>(context, listen: false);

      model.setUserProfile(userProfile);
    } else {
      print('Profile data missing.');
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SwipeablePages(),
      )
    );
  }

  Future<Map<String, dynamic>?> _fetchUserProfileData(String uid) async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        print("firestone fetch attmpted before session was establisehd");
        return null;
      }

      final String activeUid = FirebaseAuth.instance.currentUser!.uid;

      if (activeUid != uid) {
        print("mismatch in uids");
        return null;
      }

      final DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      } else {
        print("User Profile not found for UID: ${uid}");
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _navRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Register(),
      )
    );
  }

}