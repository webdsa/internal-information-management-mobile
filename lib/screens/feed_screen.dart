import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:internalinformationmanagement/flavors.dart';
import 'package:internalinformationmanagement/screens/sumary_screen.dart';
import 'package:internalinformationmanagement/service/APIService.dart';
import 'package:internalinformationmanagement/theme/theme.dart';
import 'package:internalinformationmanagement/theme/theme_provider.dart';
import 'package:internalinformationmanagement/util/Palette.dart';
import 'package:internalinformationmanagement/util/Styles.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController _searchContentController =
      TextEditingController();
    
    late Map<String, dynamic> sessionData;
  late Future<List<dynamic>> futureData;

  final APIService apiService = APIService();



  @override
  void initState() {
    super.initState();
    futureData = _fetchData();
  }

  Future<List<dynamic>> _fetchData() async {
    final String response = await rootBundle.loadString('assets/topics.json');
    sessionData = json.decode(response);
    return sessionData['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Banner(
        message: F.env,
        location: BannerLocation.topEnd,
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeArea(
                      child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () {}, icon: Icon(Icons.menu), iconSize: 35),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(top: 28.0),
                    child: TextField(
                      controller: _searchContentController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          filled: true,
                          fillColor: ShadeColors.shadeLight.withOpacity(0.05),
                          label: Text("Pesquise por um conteudo..."),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10))),
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
                                        FutureBuilder(
                      future: _fetchData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: sessionData['data'].length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(top: 38),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${sessionData['data'][index]['name']}",
                                      style: AppTextStyles.boldTitle2.merge(
                                          TextStyle(
                                              color: MainColors.primary04)),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Container(
                                      height: 200,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: sessionData['data'][index]['subTopics']
                                            .length,
                                        itemBuilder: (context, i) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Card(
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Color(0xFF328FFB)
                                                        .withOpacity(0.2),
                                                    Colors.white
                                                        .withOpacity(0.7)
                                                  ],
                                                )),
                                                width: 300.0,
                                                padding: EdgeInsets.all(16.0),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '${sessionData['data'][index]['subTopics'][i]['name']}',
                                                        style: AppTextStyles
                                                            .boldSubhead
                                                            .merge(TextStyle(
                                                                color: MainColors
                                                                    .primary04)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        }
                        return Text("null");
                      }),
                      /*Container(
                        height: 200,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                        Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Card(
                                                elevation: 2,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(12)),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      Color(0xFF328FFB)
                                                          .withOpacity(0.2),
                                                      Colors.white
                                                          .withOpacity(0.7)
                                                    ],
                                                  )),
                                                  width: 300.0,
                                                  padding: EdgeInsets.all(16.0),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16,
                                                        vertical: 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Pagamentos e Orçamentos',
                                                          style: AppTextStyles
                                                              .boldSubhead
                                                              .merge(TextStyle(
                                                                  color: MainColors
                                                                      .primary04)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Card(
                                                elevation: 2,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(12)),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      Color(0xFF328FFB)
                                                          .withOpacity(0.2),
                                                      Colors.white
                                                          .withOpacity(0.7)
                                                    ],
                                                  )),
                                                  width: 300.0,
                                                  padding: EdgeInsets.all(16.0),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16,
                                                        vertical: 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Viagens',
                                                          style: AppTextStyles
                                                              .boldSubhead
                                                              .merge(TextStyle(
                                                                  color: MainColors
                                                                      .primary04)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                            ],
                          )
                          ,
                        ),
                      )*/
                      
                      /*
                  FutureBuilder(
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
                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data['data'].length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(top: 38),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${snapshot.data['data'][index]['name']}",
                                      style: AppTextStyles.boldTitle2.merge(
                                          TextStyle(
                                              color: MainColors.primary04)),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Container(
                                      height: 200,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: snapshot
                                            .data['data'][index]['subTopics']
                                            .length,
                                        itemBuilder: (context, i) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Card(
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Color(0xFF328FFB)
                                                        .withOpacity(0.2),
                                                    Colors.white
                                                        .withOpacity(0.7)
                                                  ],
                                                )),
                                                width: 300.0,
                                                padding: EdgeInsets.all(16.0),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '${snapshot.data['data'][index]['subTopics'][i]['name']}',
                                                        style: AppTextStyles
                                                            .boldSubhead
                                                            .merge(TextStyle(
                                                                color: MainColors
                                                                    .primary04)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        }
                        return Text("null");
                      }),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
