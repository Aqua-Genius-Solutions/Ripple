// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/auth/login.dart';
import 'package:namer_app/main.dart';
import 'package:image_picker/image_picker.dart';

class CreateProfileScreen extends StatefulWidget {
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

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    print(user);
  }

  Future<void> signUp() async {
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

      if (response.statusCode == 200) {
        final responseData = response.body;

        print(responseData);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage(user: user)),
        );
      } else {
        // Error handling for Prisma backend request
        print('Prisma backend request failed with status: ${response.body}');
      }

      // Success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('User signed up successfully!'),
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
          String imageUrl = responseData['secure_url'];
          // TOD O: Text extraction will be implemented here
          Bill newBill = Bill(
              price: 23.6,
              consumption: 33,
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
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(0),
                child: Image.asset(
                  "images/rip2.png",
                  width: 240,
                  height: 240,
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
                  child: Icon(
                    Icons.add_a_photo,
                    size: 48,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              // Name Input
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8.0),
              // Nfm Input
              TextField(
                controller: nfmController,
                decoration: InputDecoration(
                  labelText: 'Nfm',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              // Image Upload Widget Below Text Fields
              Text("Your latest bill"),
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
              InkResponse(
                onTap: signUp,
                child: Image.asset(
                  'images/arrow-blue.png',
                  width: 45,
                  height: 45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class YourPrismaPackage {
  static Future<void> createUser({
    required String uid,
    required String name,
    required String nfm,
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/auth/signup'),
        body: {
          'uid': uid,
          'name': name,
          'nfm': nfm,
          'email': email,
          // Add any additional fields you want to send
        },
      );

      if (response.statusCode == 201) {
        // Request to Prisma backend successful
        final responseData = response.body;
        // Process the response data as needed
        print(responseData);
      } else {
        // Error handling for Prisma backend request
        print(
            'Prisma backend request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      // Exception handling
      print('An error occurred: $error');
    }
  }
}

class Bill {
  final double consumption;
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
