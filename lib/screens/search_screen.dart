import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internalinformationmanagement/screens/content_screen.dart';
import 'package:internalinformationmanagement/service/APIService.dart';
import 'package:internalinformationmanagement/theme/theme.dart';
import 'package:internalinformationmanagement/theme/theme_provider.dart';
import 'package:internalinformationmanagement/util/Palette.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchSubTopics();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _fetchSubTopics() async {
    var response = await apiService.fetchTopics();
    List<dynamic> subTopics = [];
    if (response['succeeded']) {
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

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filteredSubTopics = _allSubTopics
          .where((subTopic) =>
              subTopic['content'].toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
            Expanded(
              child: ListView.builder(
                itemCount: _filteredSubTopics.length,
                itemBuilder: (context, index) {
                  var subTopic = _filteredSubTopics[index];
                  return ListTile(
                    title: Text(
                      subTopic['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
