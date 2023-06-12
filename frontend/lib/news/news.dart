// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsList extends StatefulWidget {
  @override
  NewsListState createState() => NewsListState();
}

class NewsListState extends State<NewsList> {
  List<Map<String, dynamic>> newsArticles = [];
  String newsApiUrl = 'https://ripple-4wg9.onrender.com/news';

  @override
  void initState() {
    super.initState();
    fetchNewsArticles();
  }

  Future<void> fetchNewsArticles() async {
    try {
      final response = await http.get(Uri.parse(newsApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> responseBody = await jsonDecode(response.body);

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
    } catch (error) {print("errored: $error");}
    
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
          newsApiUrl: newsApiUrl,
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
  final String newsApiUrl;

  NewsCard({
    required this.id,
    required this.title,
    required this.date,
    required this.author,
    required this.likes,
    required this.newsApiUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                'By $author, $date',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 12.0),
              child: Text(
                tip,
                style: TextStyle(fontSize: 14, color: const Color.fromARGB(255, 0, 0, 0), fontStyle: FontStyle.italic),
              ),
            ),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        LikeButton(id: id, initialLikes: likes, newsApiUrl: newsApiUrl),
        CommentButton(id: id, newsApiUrl: newsApiUrl),
      ],
    );
  }
}

class LikeButton extends StatefulWidget {
  final int id;
  final int initialLikes;
  final String newsApiUrl;

  LikeButton({required this.id, required this.initialLikes, required this.newsApiUrl});

  @override
  LikeButtonState createState() => LikeButtonState();
}
// ... (previous code remains the same)

class LikeButtonState extends State<LikeButton> {
  bool _liked = false;
  int _likes = 0;

  @override
  void initState() {
    super.initState();
    _likes = widget.initialLikes;
  }

  Future<void> likeArticle() async {
    final response = await http.patch(Uri.parse('${widget.newsApiUrl}/${widget.id}/like'));

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          _likes = responseBody['likes'];
        });
      }
    } else {
      print('Failed to like article');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(
            _liked ? Icons.favorite : Icons.favorite_border,
            color: _liked ? Colors.red : null,
          ),
          onPressed: () {
            setState(() {
              _liked = !_liked;
            });
            likeArticle();
          },
          tooltip: 'Like',
        ),
        Text(_likes.toString()), // Add this line to display the number of likes
      ],
    );
  }
}

// ... (remaining code remains the same)

class CommentButton extends StatelessWidget {
  final int id;
  final String newsApiUrl;

class _CommentButtonState extends State<CommentButton> {
  void _showCommentDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add your comment'),
        content: TextField(
          decoration: InputDecoration(hintText: 'Write your comment here...'),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Submit'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.comment),
      onPressed: () {
        // Navigate to the comment page or handle the action here
      },
      tooltip: 'Comment',
    );
  }
}