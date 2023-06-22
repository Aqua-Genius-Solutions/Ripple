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
      parent: _animationController,
      curve: Curves.easeOut,
    ));
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
          events = events.map((event) {
            if (event.id == eventId) {
              return Event(
                id: event.id,
                title: event.title,
                date: event.date,
                participants: event.participants,
                likedBy: numLikes,
                image: event.image,
              );
            }
            return event;
          }).toList();
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
            print("Dis-participated from event successfully");
          } else if (message == "Participated in event successfully") {
            // Handle participate behavior$
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 4),
            child: IconButton(
              icon:
                  Image.asset('images/left-chevron.png', height: 50, width: 60),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                    return Card(
                      margin: EdgeInsets.all(16.0),
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16.0),
                                ),
                                child: Image.asset(
                                  'images/exp.jpeg',
                                  width: double.infinity,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 70, 123, 247),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16.0),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Text(
                                  DateFormat.yMMMd().format(
                                      DateTime.parse(events[index].date)),
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(16.0),
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
                                              'images/unlike.png',
                                              width: 30.0,
                                              height: 30.0,
                                            ),
                                            SizedBox(width: 5.0),
                                            Text(
                                              '${events[index].likedBy}',
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
                                          // Handle participate event here
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
                                              '${events[index].participants} Joined',
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
