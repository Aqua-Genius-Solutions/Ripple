import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsList extends StatefulWidget {
  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  List<Map<String, dynamic>> newsArticles = [];
  List<String> waterSavingTips = [
    "Every drop counts! Save water by turning off the tap while brushing your teeth or washing your hands.",
    "Take shorter showers. Reducing your shower time by just a few minutes can save gallons of water.",
    "Fix leaks promptly. A small leak can waste more than 3,000 gallons of water per year.",
    "Water your plants wisely. Water your garden during the early morning or late evening to reduce evaporation.",
    "Choose water-efficient appliances. Look for the WaterSense label when buying new appliances to save water and money on your water bill.",
  ];

  List<String> imageNames = [
    'savewater.png',
    'panda.jpg',
    'planet.jpg',
  ];

  @override
  void initState() {
    super.initState();
    fetchNewsArticles();
  }

  Future<void> fetchNewsArticles() async {
    final response =
        await http.get(Uri.parse('https://ripple-4wg9.onrender.com/news'));

    if (response.statusCode == 200) {
      final List<dynamic> responseBody = await jsonDecode(response.body);

      if (mounted) {
        setState(() {
          newsArticles = responseBody.map((article) {
            return {
              'id': article['id'] ?? '',
              'imageUrl': article['imageUrl'] ?? '',
              'title': article['title'] ?? '',
              'date': article['date'] ?? '',
              'author': article['author'] ?? '',
            };
          }).toList();
        });
      }
    } else {
      print('Failed to load news articles');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: newsArticles.length,
      itemBuilder: (context, index) {
        final isFirst = index == 0;
        final article = newsArticles[index];
        return Column(
          children: [
            if (isFirst) WaterSpillImage(),
            SizedBox(height: 16),
            SizedBox(height: 16),
            NewsCard(
              imageName: imageNames[index % imageNames.length],
              title: article['title'],
              date: article['date'],
              author: article['author'],
              tip: waterSavingTips[index % waterSavingTips.length],
            ),
          ],
        );
      },
    );
  }
}

class WaterSpillImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/phone.png',
      width: 150,
      height: 150,
    );
  }
}

class NewsCard extends StatelessWidget {
  final String imageName;
  final String title;
  final String date;
  final String author;
  final String tip;
  final int likes;

  NewsCard({
    required this.imageName,
    required this.title,
    required this.date,
    required this.author,
    required this.tip,
    this.likes = 0,
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
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: Image.asset(
                'images/$imageName',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
            ),
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
                style: TextStyle(
                    fontSize: 14,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontStyle: FontStyle.italic),
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
        LikeButton(likes: likes),
        CommentButton(),
      ],
    );
  }
}

class LikeButton extends StatefulWidget {
  final int likes;

  LikeButton({required this.likes});

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _liked ? Icons.favorite : Icons.favorite_border,
        color: _liked ? Colors.red : null,
      ),
      onPressed: () {
        setState(() {
          _liked = !_liked;
        });
      },
    );
  }
}

class CommentButton extends StatefulWidget {
  @override
  _CommentButtonState createState() => _CommentButtonState();
}

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
        _showCommentDialog(context);
      },
    );
  }
}
