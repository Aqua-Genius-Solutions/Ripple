// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> signUp() async {
    String name = nameController.text.trim();
    String surname = surnameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        surname.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      // Handle empty fields error
      return;
    }

    if (password != confirmPassword) {
      // Handle password mismatch error
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Authentication successful, do something
      print('User signed up: ${userCredential.user}');
    } on FirebaseAuthException catch (e) {
      // Handle authentication error
      print('Failed to sign up: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'images/logggo-transformed.png',
                width: 210,
                height: 210,
              ),
              SizedBox(height: 16.0),
              // Name Input
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8.0),
              // Surname Input
              TextField(
                controller: surnameController,
                decoration: InputDecoration(
                  labelText: 'Surname',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8.0),
              // Email Input
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8.0),
              // Password Input
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8.0),
              // Confirm Password Input
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              // Sign Up Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkResponse(
                    onTap: signUp,
                    child: Image.asset(
                      'images/arrow-blue.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                  SizedBox(width: 16.0),
                InkResponse(
                    onTap: signUp,
                    child: Image.asset(
                      'images/google.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                  SizedBox(width: 16.0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
