import 'package:bricd_up/constants/app_colors.dart';
import 'package:bricd_up/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  bool _passwordVisible = true;
  bool _rePasswordVisible = true;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,

      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              
              // Title
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Register",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: 450,
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Enter your email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))
                    ),
                    prefixIcon: Icon(Icons.person),
                    filled: true,
                    fillColor: AppColors.primaryBeige,
                  ),
                ),
              ),

              const SizedBox(height: 16.0,),

              // Username Input
              SizedBox(
                width: 450,
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Enter a Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    prefixIcon: Icon(Icons.person),
                    filled: true,
                    fillColor: AppColors.primaryBeige,
                  ),
                ),
              ),

              const SizedBox(height: 16.0,),

              // Password Input
              SizedBox(
                width: 450,
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Enter a Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    prefixIcon: Icon(Icons.lock),
                    filled: true,
                    fillColor: AppColors.primaryBeige,
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

              const SizedBox(height: 16.0,),

              // Re Enter Password Input
              SizedBox(
                width: 450,
                child: TextField(
                  controller: _rePasswordController,
                  decoration: InputDecoration(
                    labelText: 'Re Enter Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    filled: true,
                    fillColor: AppColors.primaryBeige,
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _rePasswordVisible = !_rePasswordVisible;
                        });
                      },
                      icon: Icon(
                        _rePasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                    )
                  ),
                  obscureText: _rePasswordVisible,
                ),
              ),

              const SizedBox(height: 16.0,),

              SizedBox(
                width: 450,
                child: ElevatedButton(
                  onPressed: _handleRegister,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: AppColors.navbarGold,
                  ),
                  child: const Text('Register'),
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

              // Register with Google Button
              // SizedBox(
              //   width: 450,
              //   child: nu,
              // ),

              // Back to Login Button
              GestureDetector(
                onTap: () => _navLogin(context),
                child: const Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text(
                    'Click here to login!',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              )

            ],
          )
        )
      ),
    );
  }

  Future<void> _handleRegister() async {
    String email = _emailController.text;
    String username = _usernameController.text;
    String password = _passwordController.text;
    String rePassword = _rePasswordController.text;

    if (email.isEmpty || username.isEmpty || password.isEmpty || rePassword.isEmpty) {
      // dp sp,etjomg
    } else if (password != rePassword) {
      // show something on the screen
    } else {
      _doRegister(email, username, password);
    }
  }

  Future<void> _doRegister(String email, String username, String password) async {
    try {
      // create user and log them in
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );

      // get unique user id from result
      final String uid = userCredential.user!.uid;

      await userCredential.user!.updateDisplayName(username);

      // write user data to db
      await _createUserDatabaseEntry(uid, email, username);

    } on FirebaseAuthException catch (error) {
      print(error);
    }
  }

  Future<void> _createUserDatabaseEntry(String uid, String email, String username) async {
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'username': username,
      'createdAt': Timestamp.now(),
    });
  }

  void _navLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Login(),
      )
    );
  }
}