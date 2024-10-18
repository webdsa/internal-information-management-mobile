// ignore_for_file: sized_box_for_whitespace, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internalinformationmanagement/models/news_model.dart';
import 'package:internalinformationmanagement/util/news_list.dart';

import '../widgets/new.dart';

class LastNewsScreen extends StatefulWidget {
  const LastNewsScreen({super.key});

  @override
  State<LastNewsScreen> createState() => _LastNewsScreenState();
}

class _LastNewsScreenState extends State<LastNewsScreen> {
  final FocusNode focusNode = FocusNode();
  List<NewsModel> listNewsFakeSearch = [];

  @override
  void initState() {
    super.initState();
    listNewsFakeSearch = listNewsFake;
  }

  searchNews(String text) {
    if (text.isEmpty) {
      setState(() {
        listNewsFakeSearch = listNewsFake;
      });
      return;
    }
    setState(() {
      listNewsFakeSearch = listNewsFake.where((element) {
        return element.title.toLowerCase().contains(text.toLowerCase());
      }).toList();
    });
  }

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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                      SizedBox(height: 41),
                      Text('Últimas notícias', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 34, color: Color(0xFF000000))),
                      Text('Igreja Adventista', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32, color: Color(0xFF1E5799))),
                      SizedBox(height: 31),
                      TextField(
                        onChanged: searchNews,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0x0D000000),
                          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(width: 1, color: Color(0xFFBAC7D5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(width: 1, color: Color(0xFFBAC7D5)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(width: 1, color: Color(0xFFBAC7D5)),
                          ),
                          hintText: 'Pesquise por um conteúdo...',
                          prefixIcon: SizedBox(child: Center(child: SvgPicture.asset('assets/svgs/nav_search.svg', width: 30)), width: 10),
                        ),
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.black),
                      ),
                      SizedBox(height: 25),
                      ...listNewsFakeSearch.map((e) => News(newsModel: e)).toList(),
                      SizedBox(height: 100),
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
                  onTap: () {
                    focusNode.requestFocus();
                  },
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
