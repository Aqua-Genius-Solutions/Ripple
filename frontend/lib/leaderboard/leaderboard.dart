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
          'images/signup-bg.png',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
        loading
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
      ]),
    );
  }
}
