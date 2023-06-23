// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:namer_app/auth/signup.dart';

import 'package:namer_app/main.dart';
import 'package:http/http.dart' as http;
import '../slide_transition.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Map<dynamic, dynamic> user = {};
  final String apiUrl = dotenv.env["API_URL"]!;

  void onSignUpPressed() {
    Navigator.push(
      context,
      SlidePageRoute(builder: (context) => SignInScreen()), //
    );
  }

  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // Handle empty fields error
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final response = await http
          .get(Uri.parse('$apiUrl/auth/getOne/${userCredential.user?.uid}'));
      print(response.body);

      setState(() {
        user = jsonDecode(response.body);
      });

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Successful'),
            content: Text('You have successfully logged in.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      Navigator.push(
          context, SlidePageRoute(builder: (context) => LoginPage()));
    } on FirebaseAuthException catch (e) {
      // Handle authentication error
      print('Failed to log in: $e');

      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Error'),
            content: Text(
                'Failed to log in. Please check your credentials and try again.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
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
      body: Stack(children: [
        Image.asset(
          'images/bg.png',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
        Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0, 16, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'images/rip2.png',
                    width: 270,
                    height: 110,
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
                  SizedBox(height: 16.0),
                  // Login Button
                  Positioned(
                    left: 20,
                    child: InkWell(
                      onTap: onSignUpPressed,
                      child: Text(
                        "Don't have an account? Sign up now!",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 24,
          bottom: 24,
          child: InkResponse(
            onTap: login,
            child: Image.asset(
              'images/arrow-blue.png',
              width: 55,
              height: 55,
            ),
          ),
        ),
      ]),
    );
  }
}
