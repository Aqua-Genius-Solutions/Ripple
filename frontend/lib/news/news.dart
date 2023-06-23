import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../slide_transition.dart';
import 'package:namer_app/profile/profile.dart';

class NewsList extends StatefulWidget {
  @override
  NewsListState createState() => NewsListState();
}

class NewsListState extends State<NewsList> {
  List<Map<String, dynamic>> newsArticles = [];
  final String apiUrl = dotenv.env["API_URL"]!;
  Map<dynamic, dynamic> user = {};
    int userBubbles = 0;

  String? uid = FirebaseAuth.instance.currentUser?.uid;
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchNewsArticles();
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

  Future<void> fetchNewsArticles() async {
    try {
      final response = await http.get(Uri.parse("$apiUrl/news"));

      if (response.statusCode == 200) {
        final List<dynamic> responseBody = jsonDecode(response.body);
        print(responseBody);
        if (mounted) {
          setState(() {
            newsArticles = responseBody.map((article) {
              return {
                'id': article['id'] ?? '',
                'title': article['title'] ?? '',
                'date': article['date'] ?? '',
                'author': article['author'] ?? '',
                'likes': article['User'].length ?? 0,
                'userLiked':
                    List<Map<String, dynamic>>.from(article['userLiked'] ?? []),
              };
            }).toList();
          });
          print("news : $newsArticles");
        }
      } else {
        print('Failed to load news articles');
      }
    } catch (error) {
      print("errored: $error");
    }
  }

  Future<void> likeNewsArticle(int articleId) async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      print("No user is currently signed in");
      return;
    }

    try {
      final response = await http.put(
        Uri.parse('$apiUrl/news/$articleId/like/${currentUser.uid}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        final int numLikes = responseData['numLikes'] as int;

        setState(() {
          newsArticles = newsArticles.map((article) {
            if (article['id'] == articleId) {
              return {
                'id': article['id'],
                'title': article['title'],
                'date': article['date'],
                'author': article['author'],
                'likes': numLikes,
                'userLiked': List<Map<String, dynamic>>.from(
                    responseData['userLiked'] ?? []),
              };
            }
            return article;
          }).toList();
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error, stackTrace) {
      print('An error occurred: $error');
      print('Stack trace: $stackTrace');
    }
  }

  

  @override
  Widget build(BuildContext context) {
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
    body: ListView.builder(
      itemCount: newsArticles.length,
      itemBuilder: (context, index) {
        final article = newsArticles[index];
        return NewsCard(
          article: article,
          likeFunction: likeNewsArticle,
        );
      },
    ),
  );
}
}

class NewsCard extends StatelessWidget {
  final Map<String, dynamic> article;
  final Function(int) likeFunction;

  NewsCard({
    required this.article,
    required this.likeFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Color.fromRGBO(246, 246, 246, 1),
      body: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('images/news.jpeg'),
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 4.0),
              child: Text(
                article['title'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 12.0),
              child: Text(
                'By ' +
                    article["author"] +
                    ' ' +
                    article["date"].substring(0, 10),
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LikeButton(
                  article: article,
                  likeFunction: likeFunction,
                ),
                IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LikeButton extends StatefulWidget {
  final Map<String, dynamic> article;
  final Function(int) likeFunction;

  LikeButton({required this.article, required this.likeFunction});

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    User? currentUser = FirebaseAuth.instance.currentUser;
    _isLiked = currentUser != null &&
        widget.article['userLiked'].contains(currentUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            _isLiked ? Icons.favorite : Icons.favorite_border,
            color: _isLiked ? Colors.red : null,
          ),
          onPressed: () {
            setState(() {
              _isLiked = !_isLiked;
            });
            widget.likeFunction(widget.article['id']);
          },
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text('${widget.article['likes']}'),
        ),
      ],
    );
  }
}
