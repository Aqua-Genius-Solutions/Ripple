import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'controller.dart';
import 'reward_item_widget.dart';

class RewardPage extends StatefulWidget {
  @override
  _RewardPageState createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  late List<dynamic> rewardData = [];
  bool loading = true;
  late Map<dynamic, dynamic> user = {};
  int userBubbles = 0;
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  final String apiUrl = dotenv.env["API_URL"]!;
  TextEditingController _descriptionController = TextEditingController();
  final CustomFlareController flareController = CustomFlareController();
  Future<void> fetchRewardData() async {
    final response = await http.get(Uri.parse('$apiUrl/rewards'));

    if (response.statusCode == 200) {
      setState(() {
        rewardData = json.decode(response.body);
        loading = false;
      });
    } else {
      throw Exception('Failed to load reward data');
    }
  }

  Future<void> spendPoints(String userId, int pointsToSpend) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/rewards/$userId/spend-points'),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({'points': pointsToSpend}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
      } else {
        final error = json.decode(response.body);
        print('Error spending points: $error');
      }
    } catch (error) {
      print('Error making request: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRewardData();
    getUser();
  }

  Future<void> getUser() async {
    final response = await http.get(Uri.parse('$apiUrl/auth/getOne/$uid'));
    print(uid);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: rewardData.length,
              itemBuilder: (context, index) {
                final reward = rewardData[index];
                return RewardItemWidget(
                  rewardItem: reward,
                  onTap: () {
                    String userId =
                        user["uid"]; // Replace this with the actual user ID
                    int pointsToSpend = reward['price'];
                    spendPoints(userId, pointsToSpend);
                  },
                  flareController: flareController,
                );
              },
            ),
    );
  }
}
