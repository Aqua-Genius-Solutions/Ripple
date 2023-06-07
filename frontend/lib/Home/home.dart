import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/events/events.dart';

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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          image: AssetImage('images/backgroundd.jpg'),
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
                  width: 70.0,
                  height: 70.0,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0, top: 16.0),
                    child: Image.asset(
                      'images/bubble2.png',
                      width: 60.0,
                      height: 60.0,
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
            Container(
              width: double.infinity,
              height: 200.0,
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(37, 87, 114, 249),
                    Color.fromARGB(15, 87, 114, 249),
                    Color.fromARGB(164, 255, 255, 255),
                  ],
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to Ripple',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Discover and join events around you.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage('images/unnamed.jpg'),
                              radius: 16.0,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              events[index].author,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Image.network(events[index].image),
                        SizedBox(height: 8.0),
                        Text(
                          events[index].date,
                          style: TextStyle(fontSize: 12.0),
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 4.0),
                            Text(events[index].participants.toString()),
                            SizedBox(width: 16.0),
                            Icon(Icons.thumb_up),
                            SizedBox(width: 4.0),
                            Text(events[index].likedBy.toString()),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventPage()),
                );
              },
              child: Text(
                'See More',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: HomePage()));
}
