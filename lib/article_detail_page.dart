import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:star_app/favorite_button.dart';

class ArticleDetailPage extends StatefulWidget {
  final String title;
  final String content;
  final String zodiacSign;
  final DateTime date;
  final String imageUrl;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final int id;

  const ArticleDetailPage({
    required this.title,
    required this.content,
    required this.zodiacSign,
    required this.date,
    required this.imageUrl,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.id,
  });

  @override
  State<ArticleDetailPage> createState() => ArticleDetailPageState();
}

class ArticleDetailPageState extends State<ArticleDetailPage> {

  void toggleFavorite() {
    setState(() {
      widget.onToggleFavorite();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> sentences = widget.content.split('.');
    final String firstParagraph = '${sentences.take(4).join('.')}.';
    final String secondParagraph = '${sentences.skip(4).join('.')}.';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color.fromARGB(255, 77, 70, 170),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Дата: ${DateFormat('d.M.y').format(widget.date)}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Знак зодиака: ${widget.zodiacSign}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16.0),
            Text(
              widget.title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
            const SizedBox(height: 16.0),
            Image.network(
              widget.imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Text(
              firstParagraph,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              secondParagraph,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            FavoriteButton(
              onToggleFavorite: toggleFavorite,
              id: widget.id,
            ),
          ],
        ),
      ),
    );
  }
}
