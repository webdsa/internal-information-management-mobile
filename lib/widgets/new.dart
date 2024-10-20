import 'package:flutter/material.dart';
import 'package:internalinformationmanagement/models/news_model.dart';

import '../screens/read_news_screen.dart';

class News extends StatelessWidget {
  const News({
    super.key,
    required this.newsModel,
  });
  final NewsModel newsModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ReadNewsScreen(newsModel: newsModel)));
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(newsModel.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF06101C))),
            SizedBox(height: 22),
            Image.asset(newsModel.imagePath, width: MediaQuery.of(context).size.width * 0.9),
            SizedBox(height: 4),
            Text(newsModel.description, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF123359)), textAlign: TextAlign.justify),
            SizedBox(height: 23),
          ],
        ),
      ),
    );
  }
}
