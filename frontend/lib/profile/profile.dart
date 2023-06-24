import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:namer_app/consumption/bar_graph.dart';
import 'package:namer_app/consumption/consumption.dart';
import 'package:namer_app/payment/bills.dart';
import 'package:namer_app/profile/Card/addcard.dart';
import 'package:permission_handler/permission_handler.dart';

import '../slide_transition.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  final cloudName = "dszx3pd6j";
  final apiKey = '471624387993618';
  final apiSecret = 'awoFoWWM-9tqhtbU3uFXZD9Dm68';
  final uploadPreset = 'ripple';

  String profilePicURL = '';
  final String apiUrl = dotenv.env["API_URL"]!;

  bool isNewsFetched = false;
  bool isEventsFetched = false;
  Map<dynamic, dynamic> user = {};

  List<Map<String, dynamic>> newsArticles = [];
  List<Map<String, dynamic>> events = [];

  List<String> waterSavingTips = [];

  String? uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    getUser();
    fetchNewsArticles();
  }

  Future<void> getUser() async {
    final response = await http.get(Uri.parse('$apiUrl/auth/getOne/$uid'));

    setState(() {
      user = jsonDecode(response.body);
    });
  }

  Future<List<dynamic>> fetchNewsArticles() async {
    final response = await http.get(Uri.parse('$apiUrl/news/user/$uid'));
    if (response.statusCode == 200) {
      final List<dynamic> responseBody = await jsonDecode(response.body);
      setState(() {
        newsArticles = responseBody.map((article) {
          return {
            'id': article['id'] ?? '',
            'image': article['image'] ?? '',
            'title': article['title'] ?? '',
            'date': article['date'] ?? '',
            'author': article['author'] ?? '',
          };
        }).toList();
        isNewsFetched = true;
      });
      print(newsArticles[0]);
      return newsArticles.toList();
    } else {
      throw Exception('Failed to fetch news articles');
    }
  }

  Future<List<dynamic>> fetchEvents() async {
    final response = await http.get(Uri.parse('$apiUrl/events/user/$uid'));
    if (response.statusCode == 200) {
      final List<dynamic> responseBody = await jsonDecode(response.body);
      print(responseBody);
      setState(() {
        events = responseBody.map((event) {
          return {
            'id': event['id'] ?? '',
            'image': event['image'] ?? '',
            'title': event['title'] ?? '',
            'date': event['date'] ?? '',
            'link': event['link'] ?? '',
          };
        }).toList();
        isEventsFetched = true;
      });

      return events.toList();
    } else {
      throw Exception('Failed to fetch events');
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

  void updateProfile() async {
    String name = nameController.text.trim();
    String lastname = lastnameController.text.trim();
    String address = addressController.text.trim();

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final response = await http.put(
          Uri.parse('$apiUrl/auth/getOne/${user.uid}'),
          body: jsonEncode({
            'Name': name,
            'Lastname': lastname,
            'Address': address,
          }),
          headers: {"Content-Type": "application/json"},
        );

        if (response.statusCode == 200) {
          final responseData = response.body;
          print(responseData);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('Profile updated successfully!'),
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
        } else {
          print(
              'Prisma backend request failed with status: ${response.statusCode}');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content:
                    Text('Failed to update the profile. Please try again.'),
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
    } catch (error) {
      print('An error occurred: $error');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(246, 246, 246, 1),
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
      body: Stack(children: [
        Image.asset(
          'images/profile-bg.png',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
        DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: profilePicURL.isNotEmpty
                      ? NetworkImage(profilePicURL)
                      : null,
                  child: profilePicURL.isEmpty
                      ? Text(
                          'Add a photo',
                          style: TextStyle(fontSize: 12.0),
                        )
                      : null,
                ),
              ),
              TabBar(
                tabs: [
                  Tab(
                      child: Text(
                    'Liked Events',
                    style: TextStyle(color: Colors.blueGrey),
                  )),
                  Tab(
                      child: Text(
                    'Liked News',
                    style: TextStyle(color: Colors.blueGrey),
                  )),
                  Tab(
                      child: Text(
                    'Profile Editing',
                    style: TextStyle(color: Colors.blueGrey),
                  )),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    FutureBuilder<List<dynamic>>(
                      future: !isEventsFetched ? fetchEvents() : null,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          if (events.isEmpty) {
                            return Center(
                              child: Text("You haven't liked any events yet"),
                            );
                          }
                          return ListView.builder(
                            itemCount: events.length,
                            itemBuilder: (context, index) {
                              final event = events[index];
                              return Column(
                                children: [
                                  SizedBox(height: 16),
                                  EventCard(
                                    id: event['id'],
                                    link: event['link'],
                                    date: DateTime.parse(event['date']),
                                    image: event['image'],
                                    title: event['title'],
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                    ListView.builder(
                      itemCount: newsArticles.length,
                      itemBuilder: (context, index) {
                        final article = newsArticles[index];
                        print('${article["image"]} ');
                        return NewsCard(
                          article: article,
                        );
                      },
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                                            await uploadImage(
                                                ImageSource.gallery);
                                          },
                                          child: Text('Gallery'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            await uploadImage(
                                                ImageSource.camera);
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
                                  border: Border.all(
                                      width: 2.0, color: Colors.blue),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: 48,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            TextField(
                              controller: lastnameController,
                              decoration: InputDecoration(
                                labelText: 'Surname',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            TextField(
                              controller: addressController,
                              decoration: InputDecoration(
                                labelText: 'Address',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        SlidePageRoute(
                                            builder: (context) => AddCard()));
                                  },
                                  child: Text(
                                    'Add a Card',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: updateProfile,
                                  child: Text('Update Profile'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            SlidePageRoute(
                                builder: (context) => BarChartWidget()));
                      },
                      child: Text('Stats'),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            SlidePageRoute(
                                builder: (context) => BillsScreen()));
                      },
                      child: Text('Payment'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class EventCard extends StatelessWidget {
  final int id;
  final String link;
  final DateTime date;
  final String image;
  final String title;

  const EventCard({
    Key? key,
    required this.id,
    required this.link,
    required this.date,
    required this.image,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.network(image),
          ListTile(
            title: Text(title),
            subtitle: Text(date.toString()),
          ),
        ],
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final Map<String, dynamic> article;

  NewsCard({
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      // elevation: 5,
      child: Container(
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.only(left: 16.0, top: 22.0, right: 25.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26.0),
                  child: Container(
                    width: double.infinity,
                    height: 800.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(article['image'] ?? ""),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 4.0),
              child: Text(
                article['title'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 12.0),
              child: Text(
                'By ' +
                    article["author"] +
                    ' ' +
                    article["date"].substring(0, 10),
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
