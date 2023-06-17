// ignore_for_file: library_private_types_in_public_api, camel_case_types

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "../classes.dart";

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  double _skygoalLogoOpacity = 0;
  final String apiUrl = dotenv.env["API_URL"]!;

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 4000),
    );
    _animationController.forward();
    super.initState();
    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _slideAnimation = Tween<Offset>(begin: Offset(0.0, 0.5), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeOut));
    fetchData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Event> events = [];

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/events'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);

        List<Event> mappedEvents = [];
        for (var event in data) {
          print(event["id"].runtimeType);
          print(event["title"].runtimeType);
          print(event["image"].runtimeType);
          print(event["date"].runtimeType);
          print("${event['LikedBy'].runtimeType} ${event['LikedBy']}");
          print(
              "${event['participants'].runtimeType} ${event['participants']}");
          mappedEvents.add(Event.fromJson(event));
        }
        print(mappedEvents);

        setState(() {
          events = mappedEvents;
        });

        await Future.delayed(Duration(milliseconds: 500));
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('An error occurred: $error');
    }
  }

  Future<void> likeEvent(int eventId) async {
    print(user);
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/events/$eventId/like/${user?.uid}'),
        headers: {'Content-Type': 'application/json'},
      );
      print(eventId);
      print(user?.uid);
      print(events);

      if (response.statusCode == 200) {
        print(response);
        final dynamic responseData = json.decode(response.body);
        final String message = responseData['message'] as String;
        final int numLikes = responseData['numLikes'] as int;
        print(responseData);
        print(numLikes);

        setState(() {
          Event event = events[eventId - 1];

          Event updatedEvent = Event(
            id: event.id,
            title: event.title,
            date: event.date,
            participants: event.participants,
            likedBy: numLikes,
            image: event.image,
          );

          events[eventId - 1] = updatedEvent;
        });

        print(message);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('An error occurred: $error');
    }
  }

  Future<void> participateInEvent(int eventId) async {
    print(user);
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/events/$eventId/part/${user?.uid}'),
        headers: {'Content-Type': 'application/json'},
      );
      print(eventId);
      print(user?.uid);
      print(events);

      if (response.statusCode == 200) {
        print(response);
        final dynamic responseData = json.decode(response.body);
        final String message = responseData['message'] as String;
        final int numParticipants = responseData['numParticipants'] as int;
        print(responseData);
        print(numParticipants);

        setState(() {
          Event event = events[eventId - 1];

          if (message == "Event dis-participated successfully") {
            // Handle dis-participate behavior
            Event updatedEvent = Event(
              id: event.id,
              title: event.title,
              date: event.date,
              participants: numParticipants,
              likedBy: event.likedBy,
              image: event.image,
            );

            events[eventId - 1] = updatedEvent;
            print("Dis-participated in event successfully");
          } else if (message == "Participated in event successfully") {
            // Handle participate behavior
            Event updatedEvent = Event(
              id: event.id,
              title: event.title,
              date: event.date,
              participants: numParticipants,
              likedBy: event.likedBy,
              image: event.image,
            );

            events[eventId - 1] = updatedEvent;
            print("Participated in event successfully");
          }

          print(message);
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('An error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(246, 246, 246, 1),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 100.0,
                    height: 100.0,
                    child: Image.asset(
                      'images/bubble2.png',
                      width: 80.0,
                      height: 80.0,
                    ),
                  ),
                  SizedBox(
                    width: 60.0,
                    height: 60.0,
                    child: Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('images/unnamed.jpg'),
                        radius: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
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
                  ),
                );
              },
            ),
            Expanded(
              child: LiquidPullToRefresh(
                onRefresh: fetchData,
                showChildOpacityTransition: false,
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(26.0),
                                  child: Image.asset(
                                    'images/exp.jpeg',
                                    width: 300.0,
                                    height: 200.0,
                                  ),
                                ),
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 1000),
                                  opacity: _skygoalLogoOpacity,
                                  child: Container(
                                    padding: EdgeInsets.only(top: 20),
                                    // height: 135,
                                    width: 164,
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 2.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 70, 123, 247),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    padding: EdgeInsets.all(6.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Image.asset(
                                        //   'images/agenda.png',
                                        //   width: 18.0,
                                        //   height: 18.0,
                                        // ),
                                        SizedBox(width: 4.0),
                                        Text(
                                          DateFormat.yMMMd().format(
                                            DateTime.parse(events[index].date),
                                          ),
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  events[index].title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          // Handle like event here
                                          likeEvent(events[index].id);
                                        },
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'images/heart1.png',
                                              width: 30.0,
                                              height: 30.0,
                                            ),
                                            SizedBox(width: 5.0),
                                            Text(
                                              '${events[index].likedBy} ',
                                              style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          // Handle like event here
                                          participateInEvent(events[index].id);
                                        },
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'images/add.png',
                                              width: 30.0,
                                              height: 30.0,
                                            ),
                                            SizedBox(width: 5.0),
                                            Text(
                                              '${events[index].participants} Joined ',
                                              style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 15.0),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
