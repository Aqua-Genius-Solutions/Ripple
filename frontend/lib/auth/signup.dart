// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

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
      print('firebase response $userCredential.user');

      String uid = userCredential.user?.uid ?? '';

      // Authentication successful, do something
      print('User signed up: ${userCredential.user}');
      // Send the data to your Prisma backend
      final response = await http.post(
          Uri.parse('https://13c2-197-27-200-206.ngrok-free.app/auth/signup'),
          body: jsonEncode({
            'uid': uid,
            'name': name,
            'surname': surname,
            'email': email,
            // Add any additional fields you want to send
          }),
          headers: {"Content-Type": "application/json"});

      if (response.statusCode == 201) {
        // Request to Prisma backend successful
        final responseData = response.body;
        // Process the response data as needed
        print(responseData);
      } else {
        // Error handling for Prisma backend request
        print('Prisma backend request failed with status: ${response.body}');
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('User signed up successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      // Handle authentication error
      print('Failed to sign up: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to sign up. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      // Exception handling
      print('An error occurred: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
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

class YourPrismaPackage {
  static Future<void> createUser({
    required String uid,
    required String name,
    required String surname,
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/auth/signup'),
        body: {
          'uid': uid,
          'name': name,
          'surname': surname,
          'email': email,
          // Add any additional fields you want to send
        },
      );

      if (response.statusCode == 201) {
        // Request to Prisma backend successful
        final responseData = response.body;
        // Process the response data as needed
        print(responseData);
      } else {
        // Error handling for Prisma backend request
        print(
            'Prisma backend request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      // Exception handling
      print('An error occurred: $error');
    }
  }
}
