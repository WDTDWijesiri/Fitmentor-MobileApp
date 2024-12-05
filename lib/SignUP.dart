import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'SignIn.dart'; // Replace with your SignIn screen file
import 'package:firebase_database/firebase_database.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

final databaseReference = FirebaseDatabase.instance.ref("Users");

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _passwordsMatch = true;
  String _errorMessage = '';

  /// Validates the email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  // Validate user input before attempting to sign up
  void _validateInput() {
    setState(() {
      _errorMessage = ''; // Reset error message

      if (_emailController.text.isEmpty) {
        _errorMessage = 'Email is required';
      } else if (!_isValidEmail(_emailController.text)) {
        _errorMessage = 'Invalid email format';
      } else if (_passwordController.text.isEmpty) {
        _errorMessage = 'Password is required';
      } else if (_passwordController.text.length < 6) {
        _errorMessage = 'Password must be at least 6 characters';
      } else if (_passwordController.text != _confirmPasswordController.text) {
        _errorMessage = 'Passwords do not match';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Center(
              child: Image.asset(
                'assets/logo/logo.png', // Update with your logo
                height: 200,
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Sign Up For Free",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text("Email Address"),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "example@gmail.com",
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Password"),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                hintText: "********",
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Confirm Password"),
            const SizedBox(height: 8),
            TextField(
              controller: _confirmPasswordController,
              obscureText: !_confirmPasswordVisible,
              onChanged: (value) {
                setState(() {
                  _passwordsMatch = _passwordController.text == value;
                });
              },
              decoration: InputDecoration(
                hintText: "********",
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _confirmPasswordVisible = !_confirmPasswordVisible;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                errorText: _passwordsMatch ? null : "Passwords do not match!",
              ),
            ),
            const SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Validate input before submitting
                  _validateInput();

                  if (_errorMessage.isEmpty) {
                    // Sanitize email to make it a valid Firebase path
                    String sanitizedEmail = _emailController.text.replaceAll('@', '_').replaceAll('.', '_');

                    // Store user data in the Firebase Realtime Database
                    databaseReference.child(sanitizedEmail).set({
                      'email': _emailController.text,
                      'password': _passwordController.text,
                    }).then((_) {
                      // Navigate to the SignIn screen on success
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SignIn()),
                      );
                    }).catchError((error) {
                      setState(() {
                        _errorMessage = 'Error: $error';
                      });
                    });
                  }
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SignIn()),
                      );
                    },
                    child: const Text("Sign In"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
