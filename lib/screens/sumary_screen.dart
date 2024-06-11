import 'package:flutter/material.dart';
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
              ExpansionTile(
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
                          )
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
