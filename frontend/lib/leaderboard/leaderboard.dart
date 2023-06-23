import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late List<dynamic> leaderboardData = [];
  final String apiUrl = dotenv.env["API_URL"]!;
  bool loading = true;

  Future<void> fetchLeaderboardData() async {
    final response = await http.get(Uri.parse('$apiUrl/auth/leaderboard'));
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
