// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:internalinformationmanagement/flavors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIService {
  final String apiURL = F.apiUrl;
  late Map<String, String> headers;
  late Completer<void> _headerCompleter;

  APIService() {
    _headerCompleter = Completer<void>();
    _initHeader();
  }

  /*
  Esta função inicializa a classe APIService, chamando o JWT_token
  salvo nas preferências compartilhadas (salvamento local do aplicativo).
  */
  Future<void> _initHeader() async {
    print('Inicializando header...');
    final prefs = await SharedPreferences.getInstance();
    final String? bearerToken = prefs.getString("jwt_token");
    if (bearerToken != null) {
      print(bearerToken);
      headers = {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      };
    } else {
      headers = {
        'Authorization':
            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6ImVEeTdTclhoUzhoRC1qN3ZCRUItUHZpV2s2MCJ9.eyJ2ZXIiOiIyLjAiLCJpc3MiOiJodHRwczovL2xvZ2luLm1pY3Jvc29mdG9ubGluZS5jb20vOTE4ODA0MGQtNmM2Ny00YzViLWIxMTItMzZhMzA0YjY2ZGFkL3YyLjAiLCJzdWIiOiJBQUFBQUFBQUFBQUFBQUFBQUFBQUFHWkpqOU4xb25qSkFYUkV5alIxcG9FIiwiYXVkIjoiM2VjZGY2ZmMtZTk3Yi00ZmVjLTg3YWItODI3YTU0ZjZkNDcxIiwiZXhwIjoxNzE4ODQwMTA0LCJpYXQiOjE3MTg3NTM0MDQsIm5iZiI6MTcxODc1MzQwNCwibmFtZSI6IkZMQU1FWklOIEhlbGwiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJmaW5vZ3MyMDAxQGdtYWlsLmNvbSIsIm9pZCI6IjAwMDAwMDAwLTAwMDAtMDAwMC0wYjU2LTY4N2FlNTczYWFiNyIsImVtYWlsIjoiZmlub2dzMjAwMUBnbWFpbC5jb20iLCJ0aWQiOiI5MTg4MDQwZC02YzY3LTRjNWItYjExMi0zNmEzMDRiNjZkYWQiLCJmYW1pbHlfbmFtZSI6IkhlbGwiLCJnaXZlbl9uYW1lIjoiRkxBTUVaSU4iLCJub25jZSI6IjAxOTAyZGI0LTIyMTctNzRiZi1iN2QwLTZkYTk3ZWQ0MjM0MyIsImFpbyI6IkR0Y0phKlkhZVRrdjRvWlBPKmIzUjhCRFd1V2lQITJTR2FqV1h5aHhzcUNoTXBaOTZUS2w2TEgwVXhWQW1uNGNaMDJTeENibU5ZUXpYbWtqTGcqejRCSU5HZ3dLak1lQndrVTluTG96NkxIRkc0Vkt0cE5QcnFiTE9SYW1va0hYS2RYVG84WnRHT2ZmdFY0ZzFVaEM0akJGZjlnTGhtMVR3N3U2Nm4xTzBFaTkifQ.HU72aJCVLHLTGJZgSaHDTMgknHl-yE41-vN44WDtUgW0JEgZGNEa54alTxOkmdgS_di39mxCo1A9ArwDkZC_AKpXsW3GXjbeBKqHWZuC4kZCS7KKne1wjHA4J7JQUl_YUXuvO5vTkAv3ghrmL_MvhAoPPvIVqc0Bu8eDKGCADglG4nB0XO6lLT_azXB5GQFvwY6bSJnJo0ED-j4BsCcT0829aImoPghUaTfV04cOnZiHllIsTA8jy3x80NB9DRcKvT-JrCMWBf9mpqJF2dfaED0bp_L1di-EoDgWczIHjVB2pTux8KTiA1ZX40NLla_NlyYtqYTK1vVSvqYmh5tBqg',
        'Content-Type': 'application/json',
      };
    }
    _headerCompleter.complete();
  }

  /*
  Esta função é responsável por buscar os tópicos da tela de resumo/feed.
  Ela retornará um json para as telas de resumo/feed.
  */
  Future<dynamic> fetchTopics() async {
    await _headerCompleter.future;
    try {
      final response =
          await http.get(Uri.parse("${apiURL}/guide/topic"), headers: headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print(
            'Erro ao buscar tópicos: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
    }
  }
}
