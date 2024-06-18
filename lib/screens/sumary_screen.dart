import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internalinformationmanagement/service/APIService.dart';
import 'dart:convert';

import 'package:internalinformationmanagement/util/Palette.dart';
import 'package:internalinformationmanagement/util/Styles.dart';

class SummaryScreen extends StatefulWidget {
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final APIService apiService = APIService();
  late Map<String, dynamic> sessionData;
  late Future<List<dynamic>> futureData;


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
                        size: 20, color: MainColors.primary04),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              FutureBuilder<List<dynamic>>(
                  future: _fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                          return ExpansionTile(
                            title: Text(
                              "${sessionData['data'][index]['name']}",
                              style: AppTextStyles.boldHeadline,
                            ),
                            children: [
                              for (var item in sessionData['data'][index]
                                  ['subTopics'])
                                ListTile(
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
                  })
              /*ExpansionTile(
                            title: Text(
                              "Pagamentos e orçamentos",
                              style: AppTextStyles.boldHeadline,
                            ),
                            children: [
                                ListTile(
                                  title: Text(
                                    "Pagamento 1",
                                    style: AppTextStyles.footnote,
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Pagamento 2",
                                    style: AppTextStyles.footnote,
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Pagamento 3",
                                    style: AppTextStyles.footnote,
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Orçamento 1",
                                    style: AppTextStyles.footnote,
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Orçamento 2",
                                    style: AppTextStyles.footnote,
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Orçamento 3",
                                    style: AppTextStyles.footnote,
                                  ),
                                )
                            ],
                          ),
                          ExpansionTile(
                            title: Text(
                              "Viagens",
                              style: AppTextStyles.boldHeadline,
                            ),
                            children: [
                                ListTile(
                                  title: Text(
                                    "Viagem 1",
                                    style: AppTextStyles.footnote,
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Viagem 2",
                                    style: AppTextStyles.footnote,
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Viagem 3",
                                    style: AppTextStyles.footnote,
                                  ),
                                ),
                            ],
                          )*/
              /*
              FutureBuilder(
                  future: apiService.fetchTopics(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                          return ExpansionTile(
                            title: Text(
                              "${snapshot.data['data'][index]['name']}",
                              style: AppTextStyles.boldHeadline,
                            ),
                            children: [
                              for (var item in snapshot.data['data'][index]
                                  ['subTopics'])
                                ListTile(
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
                  })*/
            ]),
          ),
        ),
      ),
    );
  }
}
