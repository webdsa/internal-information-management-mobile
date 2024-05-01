import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'package:internalinformationmanagement/util/Palette.dart';

class SummaryScreen extends StatefulWidget {
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  Map<String, dynamic> summaryData = {};
  int summaryLength = 0;

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    String jsonData = await rootBundle.loadString('assets/sumario.json');
    Map<String, dynamic>data = json.decode(jsonData);
    setState(() {
      summaryData = data;
      summaryLength = summaryData['summary'].length;
    });
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
            colors: [Colors.white, MainColors.primary02]
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50, left: 20),
                      child: IconButton(
                        icon: Icon(Icons.close_rounded, size: 20, color: MainColors.primary04),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: summaryLength,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      title: Text(summaryData['summary'][index]['sectionTitle']),
                      children: [
                        for (var item in summaryData['summary'][index]['items'])
                          ListTile(
                            title: Text(item),
                          ),
                        ],
                      );
                    },
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}