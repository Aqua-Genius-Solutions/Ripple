// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BillsScreen extends StatefulWidget {
  @override
  _BillsScreenState createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  List<Bill> bills = [];

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    getUser();
    importBills();
  }

  Future<void> getUser() async {
    final response = await http.get(Uri.parse(
        'https://ripple-4wg9.onrender.com/auth/profile/${user?.uid}'));

    user = jsonDecode(response.body);
  }

  Future<void> importBills() async {
    final response = await http.get(Uri.parse(
        'https://50a8-165-51-211-51.ngrok-free.app/stat/profile/1234'));

    final List<dynamic> responseData = jsonDecode(response.body);

    final List<Bill> importedBills =
        responseData.map((item) => Bill.fromJson(item)).toList();
    setState(() {
      bills = importedBills;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 80, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Bills',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: bills.length,
                itemBuilder: (context, index) {
                  final bill = bills[index];

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(34),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(159, 223, 255, 0.49),
                          Color.fromRGBO(217, 217, 217, 0)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Row(children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.17,
                        height: MediaQuery.of(context).size.height * 1,
                        padding: EdgeInsets.only(left: 24),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/water-bill.png'),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${bill.startDate.toString().substring(5, 10)}\n${bill.endDate.toString().substring(5, 10)}',
                                style: TextStyle(fontSize: 16),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 14),
                                child: Text(
                                  '${user?.displayName}',
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 80.0),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 12.0, left: 42),
                                child: Image.asset(
                                  bill.paid
                                      ? 'icons/check.png'
                                      : 'icons/warn.png',
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20, left: 8),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all<Size>(
                                    Size(100, 20),
                                  ),
                                  backgroundColor: MaterialStateProperty.all<
                                      Color>(bill
                                          .paid
                                      ? Colors.green
                                      : Colors
                                          .blue), // Change button background color
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Change border radius
                                    ),
                                  ),
                                ),
                                onPressed: bill.paid
                                    ? null
                                    : () {
                                        // Redirect logic here
                                      },
                                child: Text(
                                  '${bill.price.toStringAsFixed(2)} TND',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      )
                    ]),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Bill {
  final int id;
  final double price;
  final int consumption;
  final bool paid;
  final DateTime startDate;
  final DateTime endDate;
  final String imageUrl;
  final String userId;

  Bill({
    required this.id,
    required this.price,
    required this.consumption,
    required this.paid,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
    required this.userId,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'] as int,
      price: json['price'] as double,
      consumption: json['consumption'] as int,
      paid: json['paid'] as bool,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      imageUrl: json['imageUrl'] as String,
      userId: json['userId'] as String,
    );
  }
}
