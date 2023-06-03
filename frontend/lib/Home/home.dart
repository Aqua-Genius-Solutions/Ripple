import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
    Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/events'));

      if (response.statusCode == 200) {
        // Successful request
        final data = response.body;
        // Process the data as needed
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
  Widget build(BuildContext context) {
    fetchData();
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/backgroundd.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Hide the back button
          titleSpacing: 0.0, // Remove default title spacing
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
              SizedBox(width: 20.0), // Add spacing between the icon and title
            ],
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20, top: 16.0),
              child: CircleAvatar(
                backgroundImage: AssetImage('images/unnamed.jpg'),
                radius: 20.0, // Adjust the radius to change the size
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
              height: 400.0, // Adjust the height to make it bigger
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
                    width: 320.0, // Adjust the width as needed
                    height: 160.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  SizedBox(height: 25.0),
                  Container(
                    width: 320.0, // Adjust the width as needed
                    height: 160.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
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
