import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:finflex/api/api-config.dart';

class TestsApiService{
  static Future<http.Response> GetChapters(int userId, String token) async {
    const url = '${ApiConfiguration.baseUrl}:${ApiConfiguration.port}/test/getchapters';
    final headers = {
      'Authorization': token,
      'Content-Type': 'application/json',
    };
    //final body = json.encode({'user_id': userId});
    final Map<String, dynamic> body = {
      'user_id': userId
    };

    final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(body));
    return response;
  }

  static Future<http.Response> GetHello() async{
    const url = '${ApiConfiguration.baseUrl}:${ApiConfiguration.port}/';

    final response = await http.get(Uri.parse(url));
    return response;
  }
}

//'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMX0.00KV-iWi85eL-CZC4w5Ma2r0_dMw8ohjbjDkStIIXfQ'