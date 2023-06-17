import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class NewsList extends StatefulWidget {
  @override
  NewsListState createState() => NewsListState();
}

class NewsListState extends State<NewsList> {
  List<Map<String, dynamic>> newsArticles = [];
  final String apiUrl = dotenv.env["API_URL"]!;

  @override
  void initState() {
    super.initState();
    fetchNewsArticles();
  }

  Future<void> fetchNewsArticles() async {
    try {
      final response = await http.get(Uri.parse("$apiUrl/news"));

      if (response.statusCode == 200) {
        final List<dynamic> responseBody = jsonDecode(response.body);

        if (mounted) {
          setState(() {
            newsArticles = responseBody.map((article) {
              return {
                'id': article['id'] ?? '',
                'title': article['title'] ?? '',
                'date': article['date'] ?? '',
                'author': article['author'] ?? '',
                'likes': article['likes'] ?? 0,
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
        final dynamic responseData = json.decode(response.body);
        final int numLikes = responseData['numLikes'] as int;

        setState(() {
          // Update the state with the updated number of likes
          Map<String, dynamic> article = newsArticles[articleId - 1];

          Map<String, dynamic> updatedArticle = {
            'id': article['id'],
            'title': article['title'],
            'date': article['date'],
            'author': article['author'],
            'likes': numLikes,
          };

          newsArticles[articleId - 1] = updatedArticle;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('An error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: newsArticles.length,
      itemBuilder: (context, index) {
        final article = newsArticles[index];
        return NewsCard(
          id: article['id'],
          title: article['title'],
          date: article['date'],
          author: article['author'],
          likes: article['likes'],
          likeFunction: likeNewsArticle,
        );
      },
    );
  }
}

class NewsCard extends StatelessWidget {
  final int id;
  final String title;
  final String date;
  final String author;
  final int likes;
  final Function(int) likeFunction;

  NewsCard({
    required this.id,
    required this.title,
    required this.date,
    required this.author,
    required this.likes,
    required this.likeFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(246, 246, 246, 1),
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 4.0),
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 12.0),
              child: Text(
                'By $author, ${date.substring(0, 10)}',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LikeButton(
                  likes: likes,
                  onPressed: () => likeFunction(id),
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
  final int likes;
  final VoidCallback onPressed;

  LikeButton({required this.likes, required this.onPressed});

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiked = false;

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

              if (_isLiked) {
                widget.onPressed();
              }
            });
          },
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text('${widget.likes}'),
        ),
      ],
    );
  }
}
