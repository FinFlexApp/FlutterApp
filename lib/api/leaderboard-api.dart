import 'dart:convert';

import 'package:finflex/api/api-config.dart';
import 'package:http/http.dart' as http;

class LeaderboardApiService{
  static Future<http.Response> GetLeaders(int leadersCount, String token) async {
    const url = '${ApiConfiguration.baseUrl}:${ApiConfiguration.port}/getLeaderBoard';
    final headers = {
      'Authorization': token,
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> body = {
      'N': leadersCount
    };

    final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(body));
    return response;
  }
}