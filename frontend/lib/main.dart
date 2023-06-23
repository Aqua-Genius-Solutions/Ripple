// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:namer_app/auth/login.dart';
import 'package:namer_app/events/events.dart';
import 'package:namer_app/auth/signup.dart';
import 'package:namer_app/news/news.dart';

import 'package:namer_app/profile/profile.dart';
import 'package:namer_app/slide_transition.dart';
import 'profile/Card/addcard.dart';
import 'nav_bar.dart';
import 'Home/home.dart';
import 'payment/bills.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'rewards/rewards_page.dart';
import "chat/chat.dart";
import 'package:firebase_messaging/firebase_messaging.dart';
import 'settings/settings.dart';
import 'package:lottie/lottie.dart';
import 'rewards/rewards_page.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fixed Bottom Navbar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late final AnimationController _controller;

  bool firstPress = false;

  void _navigateToWelcomePage() {
    Navigator.push(
        context,
        SlidePageRoute(
          builder: (context) => WelcomePage(),
        ));
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToWelcomePage();
      }
    });

    _firebaseMessaging.getToken().then((token) {
      print('FCM Token: $token');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(message.notification?.title ?? ''),
          content: Text(message.notification?.body ?? ''),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WelcomePage(),
      // body: Container(
      //   decoration: BoxDecoration(
      //     gradient: LinearGradient(
      //       begin: Alignment.topCenter,
      //       end: Alignment.bottomCenter,
      //       colors: [
      //         Color.fromARGB(200, 129, 222, 248),
      //         Color.fromARGB(200, 111, 176, 255),
      //         Color.fromARGB(200, 4, 67, 144),
      //       ],
      //     ),
      //   ),
      //   child: Center(
      //     child: Lottie.network(
      //         "https://assets6.lottiefiles.com/packages/lf20_12G4mZ.json",
      //         controller: _controller, onLoaded: (compos) {
      //       _controller
      //         ..duration = Duration(milliseconds: 4000)
      //         ..forward();
      //     }),
      //   ),
      // ),
    );
  }
}

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  User? user = FirebaseAuth.instance.currentUser;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool firstPress = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _slideAnimation =
        Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, -1.0))
            .animate(_animationController);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.push(
            context, SlidePageRoute(builder: (context) => SignInScreen()));
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    if (user != null) {
      Navigator.push(
          context, SlidePageRoute(builder: (context) => LoginPage()));
    }
    setState(() {
      firstPress = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 129, 222, 248),
              Color.fromARGB(255, 111, 176, 255),
              Color.fromARGB(255, 4, 67, 144),
            ],
          ),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              SlideTransition(
                position: _slideAnimation,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                          bottomRight: Radius.circular(100),
                        ),
                        child: Container(
                          width: 270,
                          height: 290,
                          color: Color.fromRGBO(237, 237, 237, 1),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Image.asset(
                          'images/rip2.png',
                          width: 320,
                          height: 320,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.0),
              AnimatedOpacity(
                opacity: firstPress ? 1.0 : 1.0,
                duration: Duration(milliseconds: 1500),
                child: InkResponse(
                  onTap: _startAnimation,
                  child: Padding(
                      padding: EdgeInsets.only(
                        top: 70,
                        bottom: 40,
                      ),
                      child: firstPress
                          ? AnimatedOpacity(
                              opacity: firstPress ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 1500),
                              child: Text(
                                " Water is a panacea, wasting is a bad idea 🚰 ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : AnimatedOpacity(
                              opacity: firstPress ? 0.0 : 1.0,
                              duration: Duration(milliseconds: 1500),
                              child: Image.asset(
                                'images/arrow.png',
                                width: 80,
                                height: 80,
                              ),
                            )),
                ),
              ),
              SizedBox(height: 180.0),
              AnimatedOpacity(
                opacity: firstPress ? 1.0 : 0.0,
                duration: Duration(milliseconds: 1500),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.075),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              SlidePageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(screenWidth * 0.4, 50),
                            backgroundColor: Color.fromARGB(
                                255, 236, 236, 236)), // 42.5% of screen width
                        child: Text(
                          "Log In",
                          style:
                              TextStyle(fontSize: 22.0, color: Colors.blueGrey),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              SlidePageRoute(
                                  builder: (context) => SignInScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(screenWidth * 0.4, 50),
                            backgroundColor: Color.fromARGB(
                                255, 236, 236, 236)), // 42.5% of screen width
                        child: Text(
                          "Sign Up",
                          style:
                              TextStyle(fontSize: 22.0, color: Colors.blueGrey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  // final user;

  // LoginPage({required this.user});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _currentIndex = 0;
 late Map<dynamic, dynamic> user = {};
  String? uid = FirebaseAuth.instance.currentUser?.uid;
 final String apiUrl = dotenv.env["API_URL"]!;
   
    @override
  void initState() {
    super.initState();
    getUser();
    
  }
  

  Future<void> getUser() async {
    final response = await http.get(Uri.parse('$apiUrl/auth/getOne/$uid'));

    setState(() {
      user = jsonDecode(response.body);
    });
  }


  final List<Widget> _screens = [
    HomePage(),
    RewardPage(),
    NewsList(),
    ChatPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Color.fromRGBO(246, 246, 246, 1),
      //   elevation: 0,
      //   leading: Padding(
      //     padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 4),
      //     child: IconButton(
      //       icon: Image.asset('images/left-chevron.png', height: 50, width: 60),
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //     ),
      //   ),
      // ),
      body: Stack(
        children: [
          _screens[_currentIndex],
          BottomNavigationBarWidget(
            screens: _screens,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }
}

class ScreenTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Rewards Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class ScreenThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'News Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class ScreenFour extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Settings Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
