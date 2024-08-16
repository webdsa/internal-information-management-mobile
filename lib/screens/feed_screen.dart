import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internalinformationmanagement/flavors.dart';
import 'package:internalinformationmanagement/screens/content_screen.dart';
import 'package:internalinformationmanagement/screens/search_screen.dart';
import 'package:internalinformationmanagement/screens/sumary_screen.dart';
import 'package:internalinformationmanagement/service/APIService.dart';
import 'package:internalinformationmanagement/theme/theme.dart';
import 'package:internalinformationmanagement/theme/theme_provider.dart';
import 'package:internalinformationmanagement/util/Palette.dart';
import 'package:internalinformationmanagement/util/Styles.dart';
import 'package:internalinformationmanagement/widgets/custom_modal.dart';
import 'package:internalinformationmanagement/widgets/gradient_text.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedScreen extends StatefulWidget {
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController _searchContentController =
      TextEditingController();

  final APIService apiService = APIService();
  Future<dynamic>? _topicsFuture;
  String? login_type;

  @override
  void initState() {
    super.initState();
    _getJWT();
  }

  Future<void> _initialize() async {
    await _getJWT();  
    if (login_type!=null && login_type != "gmail") {
      _topicsFuture = apiService.fetchTopics();
    }
  }

  Future<void> _getJWT() async {
    final prefs = await SharedPreferences.getInstance();
    login_type = prefs.getString("login_type");
  }

  Future<void> _refreshFeed() async {
    setState(() {
      _topicsFuture = apiService.fetchTopics();
    });
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomModal();
        });
  }

  void changeContentUp(var topic, var subtopic) {
    print("${topic.index} -  ${subtopic.index}");
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Banner(
          location: BannerLocation.topEnd,
          message: F.env,
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient:
                    Provider.of<ThemeProvider>(context).themeData == darkMode
                        ? LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                                MainColors.primary03,
                                FoundationColors.foundationSecondaryDarkest
                              ])
                        : LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.white, MainColors.primary02])),
            child: RefreshIndicator(
              onRefresh: _refreshFeed,
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SafeArea(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close),
                            iconSize: 35,
                          )
                        ],
                      )),
                      Padding(
                        padding: const EdgeInsets.only(top: 28.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(wasPreviousScreenFeed: true,)));
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              color: ShadeColors.shadeLight.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.search),
                                Padding(padding: EdgeInsets.only(left: 12), child: Text("Pesquise por um conteudo..."),)
                              ],
                            ),
                          )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'Seja bem vindo ao ',
                            style: DesktopTextStyles.headlineH3
                                .merge(TextStyle(color: Color(0xFF081B28))),
                            children: [
                              TextSpan(
                                  text: 'manual',
                                  style: TextStyle(color: MainColors.primary01)),
                              TextSpan(
                                  text: ' de orientações da ',
                                  style: TextStyle(color: Color(0xFF081B28))),
                              TextSpan(
                                text: 'DSA',
                                style: TextStyle(color: MainColors.primary01),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.0),
                      Container(
                          width: 140,
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF5BFCFC).withOpacity(0.2),
                                Color(0xFF328FFB).withOpacity(0.04)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: Offset(0, 1),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: SummaryScreen(),
                                    );
                                  },
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Sumário',
                                      style: DesktopTextStyles.buttonLarge.merge(
                                          TextStyle(color: Color(0xFF081B28)))),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xFF081B28),
                                  )
                                ]),
                          )),
                      if (login_type != 'gmail')
                        Padding(
                          padding: const EdgeInsets.only(top: 28.0),
                          child: FutureBuilder(
                              future: apiService.fetchTopics(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        for (var session in snapshot.data['data'])
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${session['name']}",
                                                style: AppTextStyles.boldTitle2.merge(
                                                  TextStyle(color: MainColors.primary04),
                                                ),
                                              ),
                                              SizedBox(height: 12),
                                              Container(
                                                height: 175,
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    children: [
                                                      for (var subTopic in session['subTopics'])
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 8.0),
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => ContentScreen(
                                                                    title: session['name'],
                                                                    description: subTopic['name'],
                                                                    text: subTopic['content'],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: Card(
                                                              elevation: 4,
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  gradient: LinearGradient(
                                                                    begin: Alignment.topLeft,
                                                                    end: Alignment.bottomRight,
                                                                    colors: [
                                                                      Color(0xFF328FFB).withOpacity(0.2),
                                                                      Colors.white.withOpacity(0.7)
                                                                    ],
                                                                  ),
                                                                ),
                                                                width: 300.0,
                                                                padding: EdgeInsets.all(4.0),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(
                                                                    horizontal: 16,
                                                                    vertical: 10,
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        '${subTopic['name']}',
                                                                        style: AppTextStyles.boldSubhead.merge(
                                                                          TextStyle(color: MainColors.primary04),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${subTopic['description']}',
                                                                        style: AppTextStyles.footnote,
                                                                        overflow: TextOverflow.clip,
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top: 12.0),
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(
                                                                                  right: 6.0),
                                                                              child: Text(
                                                                                "Ver Mais",
                                                                                style: AppTextStyles.footnote.merge(
                                                                                  TextStyle(
                                                                                      color: MainColors.primary03),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Icon(
                                                                              Icons.arrow_forward_rounded,
                                                                              size: 18,
                                                                              color: Color(0xff3391FF),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 38),
                                            ],
                                          )
                                              
                                      ],
                                    ),
                                  );
                                }
                              }),
                        ),
                      if (login_type == 'gmail') 
                        Center(child: Text("Voce nao pode acessar essa pagina"),)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
