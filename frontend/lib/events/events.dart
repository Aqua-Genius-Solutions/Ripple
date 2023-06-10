// ignore_for_file: library_private_types_in_public_api, camel_case_types

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Event {
  final String author;
  final String date;
  final int participants;
  final int likedBy;
  final String image;
  Event({
    required this.author,
    required this.date,
    required this.participants,
    required this.likedBy,
    required this.image,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      author: json['author'] as String,
      date: json['date'] as String,
      participants: int.tryParse(json['participants'].toString()) ?? 0,
      likedBy: int.tryParse(json['likedBy'].toString()) ?? 0,
      image: json['image'] as String,
    );
  }
}

class EventPage extends StatefulWidget {
  @override
  _eventPageState createState() => _eventPageState();
}

class _eventPageState extends State<EventPage> {
  List<Event> events = [];

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('https://ripple-4wg9.onrender.com/events'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0, top: 16.0),
                    child: Image.asset(
                      'images/bubble2.png',
                      width: 80.0,
                      height: 80.0,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 60.0,
                      height: 60.0,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20, top: 16.0),
                        child: CircleAvatar(
                          backgroundImage: AssetImage('images/unnamed.jpg'),
                          radius: 15.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Center(
                  child: Text(
                    'Events you might like',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 26.0,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                // decoration: BoxDecoration(
                //   gradient: LinearGradient(
                //     begin: Alignment.topCenter,
                //     end: Alignment.bottomCenter,
                //     colors: [
                //       Color.fromARGB(37, 87, 114, 249),
                //       Color.fromARGB(15, 17, 129, 227),
                //       Color.fromARGB(163, 131, 219, 239),
                //     ],
                //   ),
                //   borderRadius: BorderRadius.circular(12.0),
                // ),
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(18.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      events[index].author,
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
                                        'images/agenda.png',
                                        width: 30.0,
                                        height: 30.0,
                                      ),
                                      SizedBox(width: 5.0),
                                      Text(
                                        events[index].date.substring(0, 10),
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
                                        'images/heart1.png',
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
                                borderRadius: BorderRadius.circular(26.0),
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
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
