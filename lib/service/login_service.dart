import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginService {
  String? _token;

  Future<String> authenticate(String email, String password) async {
    final response = await http.post(Uri.parse(""),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            jsonEncode(<String, String>{'email': email, 'password': password}));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      _token = data['token'];
      return _token!;
    } else {
      throw Exception('Falha ao realizar login');
    }
  }

  Future<void> login(
      BuildContext context, String email, String password) async {
    try {
      final token = await authenticate(email, password);
      _token = token;

      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      print("Erro ao fazer login: $e");
    }
  }

  Future<List<String>> fetchData() async {
    final response = await http.get(Uri.parse("uri"), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $_token'
    });

    if (response.statusCode == 200) {
      final List<dynamic> rawData = jsonDecode(response.body);
      final List<String> processedData =
          rawData.map((data) => data.toString()).toList();
      return processedData;
    } else {
      throw Exception("Falha ao obter dados");
    }
  }

  void logout(BuildContext context) {
    _token = null;
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
