// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../slide_transition.dart';

class CreateProfileScreen extends StatefulWidget {
  final String name;

  CreateProfileScreen({
    required this.name,
  });
  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfileScreen> {
  TextEditingController addressController = TextEditingController();
  TextEditingController nfmController = TextEditingController();
  final cloudName = "dszx3pd6j";
  final apiKey = '471624387993618';
  final apiSecret = 'awoFoWWM-9tqhtbU3uFXZD9Dm68';
  final uploadPreset = 'ripple';
  final String apiUrl = dotenv.env["API_URL"]!;

  String profilePicURL = '';
  String billUrl = '';
  String profilePicUrl = '';

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    super.initState();
    print(user);
  }

  void subscribeToAllUsers() {
    FirebaseMessaging.instance.subscribeToTopic('all_users');
  }

  Future<void> signUp() async {
    AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              channelKey: 'Basic_Channel',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic test')
        ],
        debug: true);
    String address = addressController.text.trim();
    String nfm = nfmController.text.trim();

    if (address.isEmpty || nfm.isEmpty) {
      // Handle empty fields error
      return;
    }
    final profileUrl = Uri.parse("$apiUrl/auth/profile/${user?.uid}");
    try {
      final response = await http.put(
        profileUrl,
        body: jsonEncode({
          'address': address,
          'NFM': int.parse(nfm),
          "profilePicURL": profilePicURL,
        }),
        headers: {"Content-Type": "application/json"},
      );
      print("Response received");

      subscribeToAllUsers();
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'Basic_Channel',
          title: "Welcome to Ripple",
          body: "Congratulations ${widget.name}, you are now part of Ripple",
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.body;

        print(responseData);
        Navigator.push(
            context, SlidePageRoute(builder: (context) => LoginPage()));
      } else {
        // Error handling for Prisma backend request
        print('Prisma backend request failed with status: ${response.body}');
      }
    } on FirebaseAuthException catch (e) {
      print('Failed to sign up: $e');

      // Failure dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to sign up. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      print('An error occurred: $error');
      // Error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> uploadImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      final imageBytes = await pickedImage.readAsBytes();

      String base64Image = base64Encode(imageBytes);

      final url =
          Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

      final response = await http.post(
        url,
        body: {
          'file': 'data:image/jpeg;base64,$base64Image',
          'upload_preset': uploadPreset,
          'api_key': apiKey,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String imageUrl = responseData['secure_url'];
        print("Image upload successful : $imageUrl");
        setState(() {
          profilePicURL = imageUrl;
        });
      } else {
        print('Failed to upload image: ${response.body}');
      }
    }
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
          setState(() {
            billUrl = responseData['secure_url'];
          });

          // TOD O: Text extraction will be implemented here
          Random random = Random();

          double price = 20 + random.nextDouble() * (40 - 20);
          int consumption = 15 + random.nextInt(40 - 15);

          Bill newBill = Bill(
              price: price,
              consumption: consumption,
              paid: true,
              imageUrl: imageUrl,
              userId: user!.uid);

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Image.asset(
          'images/profile-bg.png',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.0, 56.0, 16.0, 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Image.asset(
                    "images/rip2.png",
                    width: 240,
                    height: 110,
                  ),
                ),
                // Image Upload Widget Above Text Fields
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
                                await uploadImage(ImageSource.gallery);
                              },
                              child: Text('Gallery'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await uploadImage(ImageSource.camera);
                              },
                              child: Text('Camera'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2.0, color: Colors.blue),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: imageUrl.isNotEmpty
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(imageUrl),
                          )
                        : Icon(
                            Icons.add_a_photo,
                            size: 48,
                            color: Colors.blue,
                          ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: nfmController,
                  decoration: InputDecoration(
                    labelText: 'N° Family Members',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: EdgeInsets.all(22.0),
                  child: Text(
                    ' Your Latest Bill ',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                SizedBox(height: 16.0),
                // Sign Up Button
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(24.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: InkResponse(
              onTap: signUp,
              child: Image.asset(
                'images/arrow-blue.png',
                width: 45,
                height: 45,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class Bill {
  final int consumption;
  final double price;
  final bool paid;
  final String imageUrl;
  final DateTime startDate = DateTime.now();
  final DateTime endDate = DateTime.now();
  final String userId;
  Bill(
      {required this.consumption,
      required this.userId,
      required this.price,
      required this.paid,
      required this.imageUrl});
}
