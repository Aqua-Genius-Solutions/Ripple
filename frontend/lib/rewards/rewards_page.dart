import 'dart:convert';
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
  final String apiUrl = dotenv.env["API_URL"]!;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rewards'),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: rewardData.length,
              itemBuilder: (context, index) {
                final reward = rewardData[index];
                return RewardItemWidget(
                  rewardItem: RewardItem.fromJson(reward),
                  onTap: () {
                    String userId = "user-id"; // Replace this with the actual user ID
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