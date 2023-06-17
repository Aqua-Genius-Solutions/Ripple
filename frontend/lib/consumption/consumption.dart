import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:namer_app/consumption/bar_graph.dart';
import '../classes.dart';
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

  Future<void> importBills() async {
    final response = await http.get(Uri.parse('$apiUrl/stat')); // user/$uid

    final List<dynamic> responseData = jsonDecode(response.body);
    print(responseData);

    final List<Bill> importedBills = responseData
        .map((item) => Bill.fromJson(item as Map<dynamic, dynamic>))
        .toList();
    setState(() {
      bills = importedBills;
    });
  }

  @override
  void initState() {
    super.initState();
    importBills();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.0, top: 12.0, bottom: 4),
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(232, 255, 255, 255),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 1.5),
                ),
              ],
            ),
            child: IconButton(
              icon:
                  Image.asset('images/right-arrow.png', height: 50, width: 60),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
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
                itemCount: 6, // Number of smaller containers
                itemBuilder: (context, index) {
                  List<String> imagePaths = [
                    'images/tip1.png',
                    'images/tip2.png',
                    'images/tip3.png',
                    'images/tip4.png',
                    'images/tip7.png',
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
    );
  }
}
