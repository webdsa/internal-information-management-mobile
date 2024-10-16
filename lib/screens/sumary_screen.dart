import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internalinformationmanagement/screens/content_screen.dart';
import 'package:internalinformationmanagement/service/APIService.dart';
import 'dart:convert';

import 'package:internalinformationmanagement/util/Palette.dart';
import 'package:internalinformationmanagement/util/Styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SummaryScreen extends StatefulWidget {
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final APIService apiService = APIService();
  late Map<String, dynamic> sessionData;
  String? login_type;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _getJwt();
  }

  Future<void> _getJwt() async {
    final prefs = await SharedPreferences.getInstance();
    login_type = prefs.getString('login_type');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, MainColors.primary02]),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50, left: 20),
                  child: IconButton(
                    icon: Icon(Icons.close_rounded,
                        size: 35, color: MainColors.primary04),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
                FutureBuilder(
                  future: apiService.fetchTopics(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      print("Entrou no primeiro if");
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError || (login_type == 'gmail' || login_type == 'apple')) {
                      return Center(
                        child: Text('Não foi possível recuperar os dados'),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data['data'].length,
                        itemBuilder: (context, index) {
                          sessionData = snapshot.data;
                          return ExpansionTile(
                            title: Text(
                              "${sessionData['data'][index]['name']}",
                              style: AppTextStyles.boldHeadline,
                            ),
                            children: [
                              for (var item in sessionData['data'][index]['subTopics'])
                                ListTile(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ContentScreen(
                                        title: sessionData['data'][index]['name'],
                                        description: item['name'],
                                        text: item['content'],
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    "${item['name']}",
                                    style: AppTextStyles.footnote,
                                  ),
                                )
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
            ]),
          ),
        ),
      ),
    );
  }
}
