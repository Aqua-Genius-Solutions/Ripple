// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/events/events.dart';
import 'package:namer_app/consumption/consumption.dart';
import 'package:namer_app/payment/bills.dart';
import 'package:namer_app/profile/profile.dart';
import '../main.dart';
import "../classes.dart";
import 'package:firebase_auth/firebase_auth.dart';

import '../slide_transition.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _HomePageState extends State<HomePage> {
  List<Event> events = [];
  Map<dynamic, dynamic> user = {};
  final String apiUrl = dotenv.env["API_URL"]!;
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  TextEditingController _descriptionController = TextEditingController();

  Future<void> getUser() async {
    final response = await http.get(Uri.parse('$apiUrl/auth/getOne/$uid'));

    setState(() {
      user = jsonDecode(response.body);
    });
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

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/events/latest'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        List<Event> mappedEvents = [];
        for (var event in data) {
          mappedEvents.add(Event.fromJson(event));
        }

        setState(() {
          events = mappedEvents;
        });
        print(events);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('An error occurred: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
                  // Navigate to the notifications page
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
                    print(
                        e); // Handle any errors that might occur during sign out
                  }
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Image.asset(
              'images/bg.png', // Replace with your image asset path
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 200.0,
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(159, 223, 255, 0.79),
                        Color.fromRGBO(159, 223, 255, 0.49),
                        Color.fromRGBO(217, 217, 217, 0)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Container 1 (Left)
                      Container(
                        width: 140,
                        height: 170,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromARGB(255, 255, 255, 255),
                              Color.fromARGB(255, 255, 255, 255),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              SlidePageRoute(
                                  builder: (context) => BarChartWidget()),
                            );
                          },
                          child: Image.asset(
                            'images/consumption.png',
                            width: 50,
                            height: 30,
                          ),
                        ),
                      ),
                      // Container 2 (Right)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 150,
                            height: 74,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromARGB(255, 255, 255, 255),
                                  Color.fromARGB(255, 255, 255, 255),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  SlidePageRoute(
                                      builder: (context) => BarChartWidget()),
                                );
                              },
                              child: Image.asset(
                                'images/medd.png',
                                width: 50,
                                height: 30,
                              ),
                            ),
                          ),
                          Container(
                            width: 150,
                            height: 74,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromARGB(255, 255, 255, 255),
                                  Color.fromARGB(255, 255, 255, 255),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      SlidePageRoute(
                                          builder: (context) => BillsScreen()),
                                    );
                                  },
                                  child: Image.asset(
                                    'images/paybill.png',
                                    width: 90,
                                    height: 90,
                                  ),
                                )),
                                SizedBox(width: 8.0),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Center(
                      child: Text(
                        ' ✧ OUR LATEST EVENTS ✧',
                        style: TextStyle(
                          // fontWeight: FontWeight.w300,
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(159, 223, 255, 0.79),
                          Color.fromRGBO(159, 223, 255, 0.49),
                          Color.fromRGBO(217, 217, 217, 0)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(18.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              events[index].title,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15.0),
                                          Row(
                                            children: [
                                              Image.asset(
                                                'images/calendar.png',
                                                width: 30.0,
                                                height: 30.0,
                                              ),
                                              SizedBox(width: 5.0),
                                              Text(
                                                events[index]
                                                    .date
                                                    .substring(0, 10),
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 15.0),
                                          Row(
                                            children: [
                                              Image.asset(
                                                'images/unlike.png',
                                                width: 30.0,
                                                height: 30.0,
                                              ),
                                              SizedBox(width: 5.0),
                                              Text(
                                                '${events[index].likedBy} likes',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 15.0),
                                          Row(
                                            children: [
                                              Image.asset(
                                                'images/add.png',
                                                width: 30.0,
                                                height: 30.0,
                                              ),
                                              SizedBox(width: 5.0),
                                              Text(
                                                '${events[index].participants} participants',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 15.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 16.0, top: 22.0, right: 25.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(26.0),
                                        child: Image.asset(
                                          'images/exp.jpeg',
                                          width: 120.0,
                                          height: 150.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.0),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          SlidePageRoute(builder: (context) => EventPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 16.0),
                      ),
                      child: Text(
                        'See More',
                        style: TextStyle(
                          color: Color.fromARGB(255, 22, 56, 191),
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
