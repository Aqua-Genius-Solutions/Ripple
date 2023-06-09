// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:namer_app/payment/pay_bill.dart';

import '../classes.dart';
import '../slide_transition.dart';

class Bills {
  final int consumption;
  final double price;
  final bool paid;
  final String imageUrl;
  final DateTime startDate = DateTime.now();
  final DateTime endDate = DateTime.now();
  final String userId;
  Bills(
      {required this.consumption,
      required this.userId,
      required this.price,
      required this.paid,
      required this.imageUrl});
}

class BillsScreen extends StatefulWidget {
  @override
  _BillsScreenState createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  List<Bill> bills = [];
  Map<dynamic, dynamic> user = {};

  String? uid = FirebaseAuth.instance.currentUser?.uid;
  final cloudName = "dszx3pd6j";
  final apiKey = '471624387993618';
  final apiSecret = 'awoFoWWM-9tqhtbU3uFXZD9Dm68';
  final uploadPreset = 'ripple';
  final String apiUrl = dotenv.env["API_URL"]!;

  @override
  void initState() {
    super.initState();
    getUser();
    importBills();
  }

  Future<void> getUser() async {
    final response = await http.get(Uri.parse('$apiUrl/auth/getOne/$uid'));

    setState(() {
      user = jsonDecode(response.body);
    });
  }

  Future<void> uploadBill(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    print("converting image $pickedImage");
    if (pickedImage != null) {
      final imageBytes = await pickedImage.readAsBytes();

      String base64Image = base64Encode(imageBytes);

      final url =
          Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

      print("uploading image $base64Image");
      try {
        final response = await http.post(
          url,
          body: {
            'file': 'data:image/jpeg;base64,$base64Image',
            'upload_preset': uploadPreset,
            'api_key': apiKey,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          },
        );

        print(response.statusCode);

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final String imageUrl = responseData['secure_url'];

          // TOD O: Text extraction will be implemented here
          Random random = Random();

          double price = 20 + random.nextDouble() * (40 - 20);
          int consumption = 15 + random.nextInt(40 - 15);

          Bills newBill = Bills(
              price: price,
              consumption: consumption,
              paid: true,
              imageUrl: imageUrl,
              userId: user["uid"]);

          Map<String, dynamic> billData = {
            'consumption': newBill.consumption,
            'price': newBill.price,
            'paid': newBill.paid,
            'imageUrl': newBill.imageUrl,
            'userId': newBill.userId,
            'startDate': newBill.startDate.toIso8601String(),
            'endDate': newBill.endDate.toIso8601String(),
          };

          final billRequest = await http.post(Uri.parse("$apiUrl/stat/add"),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(billData));
          print("bill added : ${billRequest.body}");
        } else {
          print('Failed to upload image: ${response.body}');
        }
      } catch (error) {
        print("error occured : $error");
      }
    }
    importBills();
  }

  Future<void> importBills() async {
    final response =
        await http.get(Uri.parse('$apiUrl/stat/user/$uid')); // user/$uid

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 4),
          child: IconButton(
            icon: Image.asset('images/left-chevron.png', height: 50, width: 60),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(246, 246, 246, 1),
      body: Stack(children: [
        Image.asset(
          'images/bg.png',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 30, 16, 0),
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
                                    '${user["name"]} ${user["surname"]}',
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
                                  padding: EdgeInsets.only(top: 16.0, left: 38),
                                  child: Image.asset(
                                    bill.paid
                                        ? 'icons/check.png'
                                        : 'icons/warn.png',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all<Size>(
                                      Size(90, 20),
                                    ),
                                    backgroundColor: MaterialStateProperty.all<
                                            Color>(
                                        bill.paid ? Colors.green : Colors.blue),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(34.0),
                                      ),
                                    ),
                                  ),
                                  onPressed: bill.paid
                                      ? null
                                      : () {
                                          Navigator.push(
                                              context,
                                              SlidePageRoute(
                                                  builder: (context) =>
                                                      PaymentScreen(
                                                          user: user,
                                                          bill: bill)));
                                        },
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Text(
                                          '${bill.price.toStringAsFixed(2)} TND',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
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
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Upload Picture'),
                          content: Text('Select source:'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await uploadBill(ImageSource.gallery);
                              },
                              child: Text('Gallery'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await uploadBill(ImageSource.camera);
                              },
                              child: Text('Camera'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 250,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2.0, color: Colors.blue),
                      borderRadius: BorderRadius.circular(34.0),
                    ),
                    child: Icon(
                      Icons.add_a_photo,
                      size: 48,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
