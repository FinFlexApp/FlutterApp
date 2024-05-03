import 'dart:convert';

import 'package:finflex/api/api-config.dart';
import 'package:http/http.dart' as http;

class ChatApiService{
  static Future<http.Response> GetChatHistory(int userId, String token) async {
    const url = '${ApiConfiguration.baseUrl}:${ApiConfiguration.port}/bot/getChatHistory';
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

  static Future<http.Response> SendMessage(String message, int userId, String token) async {
    const url = '${ApiConfiguration.baseUrl}:${ApiConfiguration.port}/bot/sendMessage';
    final headers = {
      'Authorization': token,
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> body = {
      'user_id': userId,
      'text': message
    };

    final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(body));
    return response;
  }
}