import 'package:bricd_up/components/navbar.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  // Username and Password Text Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _passwordVisible = true;

  /// Good practice to dispose to prevent memory leaks
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffolds are basic visual structures that act as a foundation layout for a screen
    return Scaffold(
      backgroundColor: const Color(0xFF005030), // body bg color
      
      bottomNavigationBar: const NavBar(),

      // Main Body Content Here
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            // Username Input
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Enter Username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            // spacer
            const SizedBox(height: 16.0),

            // Password Input
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Enter Password',
                border: OutlineInputBorder(),
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

            // spacer
            const SizedBox(height: 16.0),

            // Login Button
            ElevatedButton(
              onPressed: _login, 
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: const Color(0xFFABE7B2)
              ),
              child: const Text('Login'),
            ),

          ],
        )
      ),
    );
  }

  /// Performs login validation logic and calls backend 
  /// TODO: setup Firebase Auth and Storage
  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing username or password field.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username: $username, Password: $password')),
      );
    }
  }
}