import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RewardPage extends StatefulWidget {
  @override
  _RewardPageState createState() => _RewardPageState();
}

class RewardsPageState extends State<RewardsPage> with SingleTickerProviderStateMixin {
  int points = 10;
  List<RewardItem> items = [];

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
