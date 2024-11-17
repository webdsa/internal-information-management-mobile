import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internalinformationmanagement/flavors.dart';
import 'package:internalinformationmanagement/screens/content_screen.dart';
import 'package:internalinformationmanagement/service/APIService.dart';
import 'package:internalinformationmanagement/theme/theme.dart';
import 'package:internalinformationmanagement/theme/theme_provider.dart';
import 'package:internalinformationmanagement/util/Palette.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  final bool wasPreviousScreenFeed;

  const SearchScreen({super.key, required this.wasPreviousScreenFeed});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  final APIService apiService = APIService();
  List<dynamic> _allSubTopics = [];
  List<dynamic> _filteredSubTopics = [];
  String? login_type;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _getJwt();

    if (login_type != null &&
        (login_type != 'gmail' && login_type != 'apple')) {
      _fetchSubTopics();
      _searchController.addListener(_onSearchChanged);
    }
  }

  Future<void> _getJwt() async {
    final prefs = await SharedPreferences.getInstance();
    login_type = prefs.getString("login_type");
  }

  Future<void> _fetchSubTopics() async {
    if (login_type != 'gmail' && login_type != 'apple') {
      var response = await apiService.fetchTopics();
      List<dynamic> subTopics = [];
      if (response['succeeded']) {
        print("Deu bom");
        List<dynamic> topics = response['data'];
        for (var topic in topics) {
          for (var subTopic in topic['subTopics']) {
            subTopic['topicName'] = topic['name'];
            subTopics.add(subTopic);
          }
        }
      }
      setState(() {
        _allSubTopics = subTopics;
        _filteredSubTopics = subTopics;
      });
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filteredSubTopics = _allSubTopics
          .where((subTopic) => subTopic['content']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
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
              colors: [Colors.white, MainColors.primary02]),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 26),
          child: Column(
            children: [
              if (widget.wasPreviousScreenFeed)
                SafeArea(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close, size: 35),
                      )
                    ],
                  ),
                ),
              if (widget.wasPreviousScreenFeed == false)
                SafeArea(child: SizedBox()),
              if (login_type != 'gmail')
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: ShadeColors.shadeLight.withOpacity(0.05),
                      label: Text("Pesquise por um conteudo..."),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              if (login_type != 'gmail')
                Expanded(
                  child: FutureBuilder(
                    future: apiService.fetchTopics(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      } else {
                        return ListView.builder(
                            itemCount: _filteredSubTopics.length,
                            itemBuilder: (context, index) {
                              var subTopic = _filteredSubTopics[index];
                              return ListTile(
                                title: Text(
                                  subTopic['name'],
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(subTopic['topicName'] ?? ''),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ContentScreen(
                                        title: subTopic['topicName'],
                                        description: subTopic['name'],
                                        text: subTopic['content'],
                                      ),
                                    ),
                                  );
                                },
                              );
                            });
                      }
                    },
                  ),
                ),
              if (login_type == 'gmail')
                Center(
                  child: Text("Voce nao pode acessar essa pagina"),
                )
            ],
          ),
        ),
      ),
    );
  }
}
