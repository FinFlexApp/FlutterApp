import 'dart:convert';

import 'package:finflex/api/api-config.dart';
import 'package:http/http.dart' as http;

class ProfileApiService{
  static Future<http.Response> GetProfileData(int userId, String token) async {
    const url = '${ApiConfiguration.baseUrl}:${ApiConfiguration.port}/users/getProfileData';
    final headers = {
      'Authorization': token,
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> body = {
      'user_id': userId
    };

    final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(body));
    return response;
  }
}