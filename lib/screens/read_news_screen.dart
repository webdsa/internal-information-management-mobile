import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internalinformationmanagement/models/news_model.dart';

class ReadNewsScreen extends StatefulWidget {
  const ReadNewsScreen({
    super.key,
    required this.newsModel,
  });
  final NewsModel newsModel;
  @override
  State<ReadNewsScreen> createState() => _ReadNewsScreenState();
}

class _ReadNewsScreenState extends State<ReadNewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFDEE9F7),
              Color(0xFFB2D6FF),
              Color(0xFFB2D6FF),
            ],
          ),
        ),
        child: Column(children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 7),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 26,
                    height: 26,
                    child: SvgPicture.asset('assets/svgs/back.svg'),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 35,
                    height: 35,
                    child: SvgPicture.asset('assets/svgs/menu.svg'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 7),
          Expanded(
            child: Stack(children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 27),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 36),
                      Text(widget.newsModel.title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Color(0xFF06101C))),
                      SizedBox(height: 18),
                      Image.asset(widget.newsModel.imagePath, width: MediaQuery.of(context).size.width * 0.9),
                      SizedBox(height: 7),
                      Text(widget.newsModel.description, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10, color: Color(0xFF06101C))),
                      SizedBox(height: 12),
                      Text(widget.newsModel.content, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13, color: Color(0xFF123359)), textAlign: TextAlign.justify),
                      SizedBox(height: 150),
                    ],
                  ),
                ),
              ),
              Positioned(
                // alignment: Alignment.bottomCenter,
                bottom: -2,
                child: Container(
                  height: 141,
                  width: MediaQuery.of(context).size.width,
                  child: SvgPicture.asset('assets/svgs/transparent_box.svg'),
                ),
              ),
            ]),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFB2D6FF),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF99B7DA),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: Offset(0, -6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 53,
                    child: SvgPicture.asset('assets/svgs/nav_home.svg'),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    child: SvgPicture.asset('assets/svgs/nav_search.svg'),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    child: SvgPicture.asset('assets/svgs/nav_newspaper.svg'),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    child: SvgPicture.asset('assets/svgs/nav_user.svg'),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
