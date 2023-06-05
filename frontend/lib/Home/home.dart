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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Event> events = [];

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('https://43ca-197-4-218-41.ngrok-free.app/events'),
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
                  width: 50.0,
                  height: 50.0,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0, top: 16.0),
                    child: Image.asset(
                      'images/bubbles.png',
                      width: 45.0,
                      height: 45.0,
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
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Container 1 (Left)
                  Container(
                    width: 140,
                    height: 170,
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                    child: Image.asset(
                      'images/stt.png',
                      width: 50,
                      height: 30,
                    ),
                  ),
                  // Container 2 (Right)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 150,
                        height: 70,
                        // margin: EdgeInsets.symmetric(
                        // horizontal: 16.0, vertical: 8.0),
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
                        child: Image.asset(
                          'images/medd.png',
                          width: 50,
                          height: 20,
                        ),
                      ),
                      Container(
                        width: 150,
                        height: 70,
                        // margin: EdgeInsets.symmetric(
                        //     horizontal: 16.0, vertical: 8.0),
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
                              child: Image.asset(
                                'images/paybill.png',
                                width: 90,
                                height: 90,
                                // fit: BoxFit.cover,
                              ),
                            ),
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
                    'OUR LATEST EVENTS',
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
                                        'images/calendar.png',
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
                                        'images/heart.png',
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
                                        'images/hands-up.png',
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
                                // Image.network(
                                //   events[index].image,
                                //   width: 100.0,
                                //   height: 100.0,
                                //   fit: BoxFit.cover,
                                // ),
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
