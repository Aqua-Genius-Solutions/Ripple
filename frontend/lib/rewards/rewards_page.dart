import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RewardPage extends StatefulWidget {
  @override
  _RewardPageState createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  late List<dynamic> rewardData = [];
  bool loading = true;

  Future<void> fetchRewardData() async {
    String apiUrl =
        'https://aca2-41-225-237-233.ngrok-free.app/erewards'; // Replace with your API URL
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      setState(() {
        rewardData = json.decode(response.body);
        loading = false;
      });
    } else {
      throw Exception('Failed to load reward data');
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
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      reward['image'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(reward['name']),
                    subtitle: Text('${reward['price']} points'),
                    trailing: IconButton(
                      icon: Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        // Add reward item to cart or perform purchase action
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
