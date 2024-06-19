// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:internalinformationmanagement/flavors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIService {
  final String apiURL = F.apiUrl;
  late Map<String, String> headers;

  APIService() {
    _initHeader();
  }

  /*

  This function initialize the APIService class, calling the JWT_token
  saved in the shared preferences (local app save).

  */
  Future<void> _initHeader() async {
    final prefs = await SharedPreferences.getInstance();
    final String? bearerToken = prefs.getString("jwt_token");
    if (bearerToken != null) {
      headers = {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      };
    } else {
      headers = {
        "Content-Type": 'application/json',
      };
    }
  }

  /*

  This function is responsible to fetch the topics from summary/feed screen.
  It will return a json to summary/feed screens.

  */
  Future<dynamic> fetchTopics() async {
    try {
      final response =
          await http.get(Uri.parse("${apiURL}/guide/topic"), headers: headers);

      if (response.statusCode == 200) {
        print(json.decode(response.body));
        return json.decode(response.body);
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
