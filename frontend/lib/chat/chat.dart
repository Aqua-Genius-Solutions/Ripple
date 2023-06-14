import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController messageController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool isCurrentUserAdmin() {
    final user = auth.currentUser;
    return user != null && user.uid == 'ADMIN_USER_UID';
  }

  bool isCurrentUserProfessional() {
    final user = auth.currentUser;
    return user != null && user.uid == 'PROFESSIONAL_USER_UID';
  }

  String getCurrentUserType() {
    if (isCurrentUserAdmin()) {
      return 'admin';
    } else if (isCurrentUserProfessional()) {
      return 'professional';
    } else {
      return 'unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/water.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('💬 lets brainstorm here'),
          backgroundColor: Color.fromARGB(255, 88, 224, 255),
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('chat_messages')
                    .where('userType', isEqualTo: getCurrentUserType())
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
                      final text = message['text'] as String?;

                      return ListTile(
                        title: Text(text ?? ''),
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
                        firestore.collection('chat_messages').add({
                          'text': message,
                          'sender': 'User', // Replace with sender's name
                          'userType': getCurrentUserType(),
                          'timestamp': DateTime.now().toUtc(),
                        });
                        messageController.clear();
                      }
                    },
                    child: Text('Send'),
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 88, 224,
                            255) // Set the button's background color
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
