import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:namer_app/slide_transition.dart';

import 'main.dart';
import 'profile/profile.dart';
import 'settings/settings.dart';

import 'package:http/http.dart' as http;

class BottomNavigationBarWidget extends StatefulWidget {
  final int currentIndex;
  final List<Widget> screens;
  final ValueChanged<int> onTap;

  BottomNavigationBarWidget({
    required this.currentIndex,
    required this.onTap,
    required this.screens,
  });

  @override
  _BottomNavigationBarWidgetState createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  late String userBubbles = "0";
  bool isPro = false;
  Map<dynamic, dynamic> user = {};

  final String apiUrl = dotenv.env["API_URL"]!;
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  TextEditingController _descriptionController = TextEditingController();

  Future<void> getUser() async {
    final response = await http.get(Uri.parse('$apiUrl/auth/getOne/$uid'));

    setState(() {
      user = jsonDecode(response.body);
      userBubbles = user['Bubbles']?.toString() ?? "0";
      isPro = user['isPro'];
    });

    print(userBubbles);
    print(user['Bubbles']);
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> requestPro(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text('Become Pro'),
        content: TextField(
          controller: _descriptionController,
          decoration: InputDecoration(hintText: 'Enter description'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              String description = _descriptionController.text.trim();
              if (description.isNotEmpty) {
                await _sendToApi(description);
                Navigator.of(dialogContext).pop();
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendToApi(String description) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/auth/request/$uid'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"desc": description}),
      );

      // Handle response according to your API's documentation.
      if (response.statusCode == 200) {
        print('Success');
      } else {
        print('Error');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  final List<List<String>> _iconData = [
    [
      'icons/home.png',
      'icons/home1.png',
    ],
    [
      'icons/trophy.png',
      'icons/trophy1.png',
    ],
    [
      'icons/news.png',
      'icons/news1.png',
    ],
    [
      'icons/chat.png',
      'icons/chat1.png',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(246, 246, 246, 1),
      appBar: widget.currentIndex == 3 && !isPro
          ? null
          : PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight + 16.0),
              child: Padding(
                padding: EdgeInsets.only(top: 16),
                child: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.menu),
                      color: Color.fromARGB(255, 13, 183, 226),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: Row(
                        children: [
                          Text(
                            userBubbles,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 56, 56, 56),
                              fontSize: 16,
                            ),
                          ),
                          Image.asset(
                            'images/bubble2.png',
                            width: 40,
                            height: 40,
                            // Adjust the width and height as needed
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              onDetailsPressed: () {
                Navigator.push(context,
                    SlidePageRoute(builder: (context) => ProfileScreen()));
              },
              accountName: Text("${user['name'] ?? ""}"),
              accountEmail: Text('${user['email'] ?? ""}'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(user['Image'] ?? ""),
                radius: 50, // Adjust the radius as per your requirement
              ),
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () {
                Navigator.push(context,
                    SlidePageRoute(builder: (context) => SettingsPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text('Become Pro'),
              onTap: () => requestPro(context),
            ),
            Expanded(child: SizedBox()),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.push(context,
                      SlidePageRoute(builder: (context) => MyHomePage()));
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: widget.currentIndex,
        children: widget.screens,
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 159, 223, 255),
              offset: Offset(1, 0),
              blurRadius: 8.0,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34.0),
          child: BottomNavigationBar(
            currentIndex: widget.currentIndex,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: widget.onTap,
            items: List.generate(_iconData.length, (index) {
              final List<String> icons = _iconData[index];
              final unselectedIcon = icons[0];
              final selectedIcon = icons[1];

              return BottomNavigationBarItem(
                icon: Image.asset(
                  widget.currentIndex == index ? selectedIcon : unselectedIcon,
                ),
                label: '',
              );
            }),
          ),
        ),
      ),
    );
  }
}
