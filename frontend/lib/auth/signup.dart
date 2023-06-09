// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';

import 'login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../slide_transition.dart';
import 'profile_creation.dart';

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

  final String apiUrl = dotenv.env["API_URL"]!;

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

      String uid = userCredential.user?.uid ?? '';

      // Authentication successful, do something
      print('User signed up: ${userCredential.user}');

      final response = await http.post(Uri.parse('$apiUrl/auth/signup'),
          body: jsonEncode({
            'uid': uid,
            'name': name,
            'surname': surname,
            'email': email,
          }),
          headers: {"Content-Type": "application/json"});
      print("Respone received : ${response.body}");

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text(
                'Your account has been created! Continue to complete your profile'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      SlidePageRoute(
                          builder: (context) =>
                              CreateProfileScreen(name: name)));
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
      backgroundColor: Color.fromRGBO(246, 246, 246, 1),
      body: Stack(
        children: [
          Image.asset(
            'images/signup-bg.png',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Image.asset(
                          'images/rip2.png',
                          width: 210,
                          height: 110,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 70.0),
                                  child: Container(
                                    height: 40,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.3, vertical: 5.3),
                                          child: InkResponse(
                                            onTap: signUp,
                                            child: Image.asset(
                                              'images/google.png',
                                              width: 25,
                                              height: 25,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 4.0),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.3, vertical: 5.3),
                                          child: Text(
                                            'Signup with Google',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Color.fromARGB(
                                                    255, 133, 133, 133)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        // Login Text
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              SlidePageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          },
                          child: Text(
                            'Already have an account? Login',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: InkResponse(
                onTap: signUp,
                child: Image.asset(
                  'images/arrow-blue.png',
                  width: 45,
                  height: 45,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
