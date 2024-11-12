import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'article_detail_page.dart';
import 'articles.dart';
import 'user.dart';
import 'favorite_button.dart';

class AstrologyHomePage extends StatefulWidget {
  final User user;

  const AstrologyHomePage({super.key, required this.user});

  @override
  _AstrologyHomePageState createState() => _AstrologyHomePageState();
}

class _AstrologyHomePageState extends State<AstrologyHomePage> {
  String? selectedZodiacSign;
  String selectedDateFilter = 'All';
  List<String> zodiacSigns = [
    'Овен',
    'Телец',
    'Близнецы',
    'Рак',
    'Лев',
    'Дева',
    'Весы',
    'Скорпион',
    'Стрелец',
    'Козерог',
    'Водолей',
    'Рыбы'
  ];
  List<String> dateFilters = ['All', 'Day', 'Week', 'Month'];

  DateTime get currentDate => DateTime.now();

  DateTime get startOfWeek =>
      currentDate.subtract(Duration(days: currentDate.weekday - 1));

  DateTime get endOfWeek => startOfWeek.add(const Duration(days: 6));

  @override
  void initState() {
    super.initState();
    selectedZodiacSign = widget.user.getZodiacSign();
  }

  List<Article> get filteredArticles {
    return articles.where((article) {
      bool zodiacMatch = selectedZodiacSign == null ||
          article.zodiacSign == selectedZodiacSign;
      bool dateMatch = true;

      DateTime articleDate = article.date;

      if (selectedDateFilter == 'Day') {
        dateMatch = articleDate.year == currentDate.year &&
            articleDate.month == currentDate.month &&
            articleDate.day == currentDate.day;
      } else if (selectedDateFilter == 'Week') {
        dateMatch = articleDate
                .isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
            articleDate.isBefore(endOfWeek.add(const Duration(days: 2)));
      } else if (selectedDateFilter == 'Month') {
        dateMatch = articleDate.year == currentDate.year &&
            articleDate.month == currentDate.month;
      }

      return zodiacMatch && dateMatch;
    }).toList();
  }

  void toggleFavorite() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 77, 70, 170),
        automaticallyImplyLeading: false,
        title: const Text('Новости'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Выберите знак зодиака:'),
              ),
              // Expanded(
              //   child:
              DropdownButton<String>(
                alignment: Alignment.center,
                hint: Text('Выберите знак зодиака'),
                value: selectedZodiacSign,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedZodiacSign = newValue;
                  });
                },
                items:
                    zodiacSigns.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          Row(children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Выберите фильтр даты:'),
            ),
            // Expanded(
            //   child:
            DropdownButton<String>(
              alignment: Alignment.center,
              hint: Text('Выберите фильтр даты'),
              value: selectedDateFilter,
              onChanged: (String? newValue) {
                setState(() {
                  selectedDateFilter = newValue!;
                });
              },
              items: dateFilters.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ]),
          Expanded(
            child: ListView.builder(
              itemCount: filteredArticles.length,
              itemBuilder: (context, index) {
                final article = filteredArticles[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Дата: ${DateFormat('d.M.y').format(article.date)}',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Знак зодиака: ${article.zodiacSign}',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 8.0),
                          Image.network(
                            article.imageUrl,
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            article.content,
                            style: const TextStyle(fontSize: 14.0),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8.0),
                          FavoriteButton(
                            onToggleFavorite: toggleFavorite,
                            id: filteredArticles[index].id,
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleDetailPage(
                            title: article.title,
                            content: article.content,
                            zodiacSign: article.zodiacSign,
                            date: article.date,
                            imageUrl: article.imageUrl,
                            isFavorite: article.isFavorite,
                            onToggleFavorite: toggleFavorite,
                            id: filteredArticles[index].id,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
