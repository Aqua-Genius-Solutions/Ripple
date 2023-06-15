import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    final User? user = _auth.currentUser;
    final response = await http.get(Uri.parse(
        'https://8151-41-225-237-233.ngrok-free.app/auth/getOne/${user?.uid}'));

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
        appBar: AppBar(
          title: Text('💬 let\'s brainstorm here'),
        ),
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
        title: Text('💬 let\'s brainstorm here'),
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
                    final senderId = message['senderId'] as String?;

                    if (senderId == _currentUser?["uid"]) {
                      return Container();
                    }

                    return ListTile(
                      title: Text(text ?? ''),
                      subtitle: Text(senderId ?? ''),
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
