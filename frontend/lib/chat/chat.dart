import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../slide_transition.dart';
import 'package:namer_app/profile/profile.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<dynamic, dynamic>? _currentUser;
  bool _isProUser = false;
  final String? apiUrl = dotenv.env["API_URL"];
  Map<dynamic, dynamic> user = {};
    int userBubbles = 0;

  String? uid = FirebaseAuth.instance.currentUser?.uid;
  TextEditingController _descriptionController = TextEditingController();


  @override
  void initState() {
    super.initState();
    getCurrentUser();
     getUser();
  }

  Future<void> getUser() async {
    final response = await http.get(Uri.parse('$apiUrl/auth/getOne/$uid'));

    setState(() {
      user = jsonDecode(response.body);
      userBubbles = user['bubbles'] ?? 0;
    });
  }

  Future<void> requestPro(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text('Become Pro'),
        content: TextField(
          controller: _descriptionController,
          decoration: InputDecoration(hintText: 'Enter description'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              String description = _descriptionController.text.trim();
              if (description.isNotEmpty) {
                await _sendToApi(description);
                Navigator.of(dialogContext).pop();
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendToApi(String description) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/auth/request/$uid'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"desc": description}),
      );

      // Handle response according to your API's documentation.
      if (response.statusCode == 200) {
        print('Success');
      } else {
        print('Error');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<void> getCurrentUser() async {
    final User? user = _auth.currentUser;
    final response =
        await http.get(Uri.parse('$apiUrl/auth/getOne/${user?.uid}'));

    print("response received : ${response.body}");
    setState(() {
      _currentUser = jsonDecode(response.body);
      _isProUser = _currentUser?['isPro'] ?? false;
    });
  }

  Future<void> sendMessage(String messageText) async {
    print(messageText);
    if (messageText.trim().isEmpty) return;

    const chatId = 'chat';
    final senderId = _currentUser?["uid"];
    final senderName = _currentUser?["name"];
    final senderSurname = _currentUser?["surname"];

    final timestamp = DateTime.now().toUtc();
    print("Message sent to $senderId");

    try {
      await firestore
          .collection('chat_messages')
          .doc(chatId)
          .collection('messages')
          .add({
        'senderId': senderId,
        'senderName': senderName,
        'senderSurname': senderSurname,
        'messageText': messageText,
        'timestamp': timestamp,
      });
      messageController.clear();
      print("Message sent to $senderId");
    } catch (error) {
      print('Error sending message: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isProUser) {
      return Scaffold(

        backgroundColor: Color.fromRGBO(246, 246, 246, 1),
        body: Center(
          child: Text(
            'You need to be a Pro user to access the chat.',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu),
          color: Color.fromARGB(255, 13, 183, 226),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Row(
                children: [
                  Text(
                    userBubbles.toString(),
                    style: TextStyle(
                      color: const Color.fromARGB(255, 56, 56, 56),
                      fontSize: 16,
                    ),
                  ),
                  Image.asset(
                    'images/bubble2.png',
                    width: 50,
                    height: 50,
                    // Adjust the width and height as needed
                  ),
                ],
              ),
            )
          ],
    ),
    drawer: Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            onDetailsPressed: () {
              Navigator.push(context, SlidePageRoute(builder: (context) => ProfileScreen()));
            },
            accountName: Text("${user['name'] ?? ""}"),
            accountEmail: Text('${user['email'] ?? ""}'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(user['Image'] ?? ""),
              radius: 50,
            ),
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {
              // Navigate to the notifications page
            },
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Become Pro'),
            onTap: () => requestPro(context),
          ),
          Expanded(child: SizedBox()),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              // Perform logout action
            },
          ),
        ],
      ),
    ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('chat_messages')
                  .doc('chat')
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data?.docs ?? [];

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message =
                        messages[index].data() as Map<String, dynamic>;
                    final text = message['messageText'] as String?;
                    final senderName = message['senderName'] as String?;
                    final senderSurname = message['senderSurname'] as String?;
                    final isCurrentUser =
                        message['senderId'] == _currentUser?["uid"];

                    // Determine the alignment based on whether the message is from the current user or another user
                    final alignment = isCurrentUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start;

                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: alignment,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: isCurrentUser
                                  ? Color.fromARGB(255, 13, 183, 226)
                                  : Color.fromARGB(255, 132, 223,
                                      246), // Same color as your messages
                            ),
                            child: Text(
                              text ?? '',
                              style: TextStyle(
                                color: isCurrentUser
                                    ? Color.fromARGB(255, 0, 0, 0)
                                    : Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            senderName ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final message = messageController.text.trim();
                    if (message.isNotEmpty) {
                      sendMessage(message);
                    }
                  },
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Chat App',
    home: ChatPage(),
  ));
}
