// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:internalinformationmanagement/flavors.dart';

class APIService {
  final String bearerToken = dotenv.get("TEST_TOKEN");
  final String apiURL = F.apiUrl;
  late Map<String, String> headers;

  APIService() {
    this.headers = {
      'Authorization': 'Bearer $bearerToken',
      'Content-Type': 'application/json',
    };
  }

  Future<dynamic> fetchTopics() async {
    try {
      final response =
          await http.get(Uri.parse("${apiURL}/guide/topic"), headers: headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
