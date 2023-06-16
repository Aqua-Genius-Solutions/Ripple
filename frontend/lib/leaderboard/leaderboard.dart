import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late List<dynamic> leaderboardData = [];
  bool loading = true;

  Future<void> fetchLeaderboardData() async {
    String apiUrl = 'https://0b2a-41-225-237-233.ngrok-free.app/leaderboard'; // Replace with your API URL
    final response = await http.get(Uri.parse(apiUrl));
    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        leaderboardData = json.decode(response.body)['data'];
        loading = false;
      });
    } else {
      throw Exception('Failed to load leaderboard data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLeaderboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: leaderboardData.length,
              itemBuilder: (context, index) {
                final user = leaderboardData[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user['Image']),
                  ),
                  title: Text('${user['name']} ${user['surname']}'),
                  trailing: Text('${user['Bubbles']} Bubbles'),
                );
              },
            ),
    );
  }
}