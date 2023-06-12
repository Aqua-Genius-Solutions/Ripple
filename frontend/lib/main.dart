// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:namer_app/news/news.dart';
import 'package:namer_app/rewards/rewards_page.dart';
import 'package:namer_app/news/news.dart';
import 'profile/Card/addcard.dart';
import 'nav_bar.dart';
import 'home/home.dart';
import 'auth/signup.dart';
import 'auth/login.dart';
import 'profile/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'news/news.dart';

void main() async {
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

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WelcomePage(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

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
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
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
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(124),
                        bottomRight: Radius.circular(124),
                      ),
                      child: Container(
                        width: 320,
                        height: 420,
                        color: Color.fromRGBO(237, 237, 237, 1),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Image.asset(
                        'images/rip2.png',
                        width: 300,
                        height: 300,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: _startAnimation,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 70,
                    bottom: 40,
                  ),
                  child: Image.asset(
                    'images/arrow.png',
                    width: 80,
                    height: 80,
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
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomePage(),
    RewardsPage(),
    NewsList(),
    EventPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(''),
      ),
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
