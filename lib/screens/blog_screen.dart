import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internalinformationmanagement/screens/last_news_screen.dart';
import 'package:internalinformationmanagement/util/news_list.dart';

import '../models/news_model.dart';
import '../widgets/new.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
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
                      Text('Bem-vinda', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 34, color: Colors.black)),
                      Text('Amanda', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32, color: Colors.black)),
                      SizedBox(height: 28),
                      TextField(
                        onChanged: searchNews,
                        focusNode: focusNode,
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
                      SizedBox(height: 33),
                      GestureDetector(
                        onTap: () {
                          print('Manual de orientações');
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                          width: 155,
                          height: 129,
                          decoration: BoxDecoration(
                            color: Color(0xFFC0DDFF),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x0D000000),
                                blurRadius: 10,
                                offset: Offset(0, 0),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                padding: EdgeInsets.all(13),
                                decoration: BoxDecoration(
                                  color: Color(0xFFE0EFFF),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: SvgPicture.asset(
                                  'assets/svgs/assignment_ind.svg',
                                  color: Color(0xFF3391FF),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text('Manual de', style: TextStyle(color: Color(0xFF3391FF), fontWeight: FontWeight.w400, fontSize: 12)),
                              Text('ORIENTAÇÕES', style: TextStyle(color: Color(0xFFB0A9FF), fontWeight: FontWeight.w700, fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 33),
                      Text('Acompanhe aqui suas', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Color(0xFF06101C))),
                      Text('Últimas atualizações', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF3391FF))),
                      SizedBox(height: 11.5),
                      Divider(color: Color(0xFFDEDDE4), height: 0, thickness: 0.5, endIndent: 50),
                      SizedBox(height: 11.5),
                      ...listNewsFakeSearch.take(3).map((e) => News(newsModel: e)).toList(),
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
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LastNewsScreen()));
                  },
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
