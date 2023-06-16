import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:namer_app/consumption/bar_graph.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class BarChartWidget extends StatefulWidget {
  const BarChartWidget({Key? key}) : super(key: key);

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  List<Bill> bills = [];
  User? user = FirebaseAuth.instance.currentUser;
  final String apiUrl = dotenv.env["API_URL"]!;

  Future<void> fetchData() async {
    print(user);

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/stat'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final List<Bill> importedBills = data
            .map((item) => Bill.fromJson(item as Map<String, dynamic>))
            .toList();

        setState(() {
          bills = importedBills;
        });
        print(bills);
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
      margin: EdgeInsets.only(top: 25.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/backgroundd.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 70.0,
                    height: 70.0,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.0),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Text(
                        'Your Quarterly Water Consumption',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        height: 300,
                        width: 310,
                        child: MyBarGraph(
                          bills: bills,
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    Column(
                      children: [
                        Center(
                          child: Text(
                            'How can we save water ?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Container(
                      height: 640,
                      width: double.infinity,
                      margin:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                        itemCount: 6, // Number of smaller containers
                        itemBuilder: (context, index) {
                          List<String> imagePaths = [
                            'images/tip1.png',
                            'images/tip2.png',
                            'images/tip3.png',
                            'images/tip4.png',
                            'images/tip5.png',
                            'images/tip6.png'
                          ];

                          return Container(
                            margin: EdgeInsets.all(10.0),
                            width: 200.0,
                            height: 120.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 15.0, top: 12.0, right: 15.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(26.0),
                                      child: Image.asset(
                                        imagePaths[index],
                                        width: 200.0,
                                        height: 200.0,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
