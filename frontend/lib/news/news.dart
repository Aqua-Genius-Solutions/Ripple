// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsList extends StatefulWidget {
  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  List<Map<String, dynamic>> newsArticles = [];

  @override
  void initState() {
    super.initState();
    fetchNewsArticles();
  }

  Future<void> fetchNewsArticles() async {
    final response =
        await http.get(Uri.parse('https://ripple-4wg9.onrender.com/news'));

    if (response.statusCode == 200) {
      final List<dynamic> responseBody = jsonDecode(response.body);
      setState(() {
        newsArticles = responseBody
            .map((article) => {
                  'id': article['id'],
                  'imageUrl': article['imageUrl'],
                  'title': article['title'],
                  'date': article['date'],
                  'author': article['author'],
                })
            .toList();
      });
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
            NewsCard(
              imageUrl: article['imageUrl'],
              title: article['title'],
              date: article['date'],
              author: article['author'],
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
      fit: BoxFit.cover,
    );
  }
}

class NewsCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String date;
  final String author;
  NewsCard({
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(imageUrl),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('By $author, $date'),
          ),
        ],
      ),
    );
  }
}
