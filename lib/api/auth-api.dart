import 'dart:convert';

import 'package:finflex/api/api-config.dart';
import 'package:http/http.dart' as http;

class AuthApiService{
  static Future<http.Response> Login(String email, String password) async {
    const url = '${ApiConfiguration.baseUrl}:${ApiConfiguration.port}/users/login';
    final headers = {
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> body = {
      'email': email,
      'password': password
    };

    final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(body));
    return response;
  }

  static Future<http.Response> Register(String email, String nickname, String firstname, String surname, String password) async {
    const url = '${ApiConfiguration.baseUrl}:${ApiConfiguration.port}/users/register';
    final headers = {
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> body = {
      'email': email,
      'nickname': nickname,
      'firstname': firstname,
      'surname': surname,
      'password': password
    };

    final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(body));
    return response;
  }

  static Future<http.Response> CheckToken(int userId, String token) async {
    const url = '${ApiConfiguration.baseUrl}:${ApiConfiguration.port}/token';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': token
    };
    final Map<String, dynamic> body = {
      'user_id': userId
    };

    final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(body));
    return response;
  }
}