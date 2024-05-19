import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:internalinformationmanagement/flavors.dart';

class APIService {
  final String bearerToken = dotenv.get("");
  final String apiURL = F.apiUrl;
  final Map<String, String> headers = {
    'Authorization': 'Bearer ',
    'Content-Type': 'application/json',
  };

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
