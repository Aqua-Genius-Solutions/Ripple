import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String eventData = ''; // Variable to store the event data

  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('https://ripple-4wg9.onrender.com/events'));

      if (response.statusCode == 200) {
        // Successful request
        final data = response.body;
        setState(() {
          eventData = data; // Store the response data in the variable
        });
        print(data);
      } else {
        // Error handling
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      // Exception handling
      print('An error occurred: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Call the fetchData method when the widget initializes
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0.0,
          title: Row(
            children: [
              SizedBox(
                width: 80.0,
                height: 80.0,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 16.0),
                  child: Image.asset(
                    'images/bubbles.png',
                    width: 64.0,
                    height: 64.0,
                  ),
                ),
              ),
              SizedBox(width: 20.0),
            ],
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20, top: 16.0),
              child: CircleAvatar(
                backgroundImage: AssetImage('images/unnamed.jpg'),
                radius: 20.0,
              ),
            ),
          ],
        ),
        body: Column(
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
                  // Add your components here
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 400.0,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 25.0),
                  Container(
                    width: 320.0,
                    height: 160.0,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Center(
                      child: Text(
                        'Event: $eventData',
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.0),
                        // Add your components here
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
