import 'package:flutter/material.dart';
import 'package:star_app/favorite_articles.dart';
import 'articles.dart';

class FavoriteButton extends StatefulWidget {
  final VoidCallback onToggleFavorite;
  final int id;

  const FavoriteButton({
    super.key,
    required this.onToggleFavorite,
    required this.id,
  });

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.favorite_border),
      selectedIcon: const Icon(Icons.favorite),
      color: articles[widget.id].colorFavoriteButton,
      onPressed: () {
        if (articles[widget.id].isFavorite == false) {
          favoriteArticles.add(Article(
            id: articles[widget.id].id,
            title: articles[widget.id].title,
            content: articles[widget.id].content,
            zodiacSign: articles[widget.id].zodiacSign,
            date: articles[widget.id].date,
            imageUrl: articles[widget.id].imageUrl,
            isFavorite: articles[widget.id].isFavorite,
            colorFavoriteButton: articles[widget.id].colorFavoriteButton,
          ));
          articles[widget.id].colorFavoriteButton =
              const Color.fromARGB(255, 55, 0, 253);
          setState(() {
            articles[widget.id].isFavorite = !articles[widget.id].isFavorite;
            widget.onToggleFavorite();
          });
        } else {
          favoriteArticles.removeWhere(
              (element) => element.content == articles[widget.id].content);
          articles[widget.id].colorFavoriteButton = Colors.grey;
          setState(() {
            articles[widget.id].isFavorite = !articles[widget.id].isFavorite;
            widget.onToggleFavorite();
          });
        }
      },
    );
  }
}
