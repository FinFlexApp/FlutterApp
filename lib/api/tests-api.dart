import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:finflex/api/api-config.dart';

class TestsApiService{
  // Запрос на получение глав для рендера меню глав
  static Future<http.Response> GetChapters(int userId, String token) async {
    const url = '${ApiConfiguration.baseUrl}:${ApiConfiguration.port}/test/getchapters';
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

  // Запрос на получение тестов для рендера меню тестов глав
  static Future<http.Response> GetChapterTests(int chapterId, int userId, String token) async {
    const url = '${ApiConfiguration.baseUrl}:${ApiConfiguration.port}/test/getChapterTests';
    final headers = {
      'Authorization': token,
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> body = {
      'user_id': userId,
      'chapter_id': chapterId
    };

    final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(body));
    return response;
  }

  // Запрос на получение списка вопросов теста
  static Future<http.Response> getQuestionsList(int testId, String token) async {
    const url = '${ApiConfiguration.baseUrl}:${ApiConfiguration.port}/test/getQuestionsList';
    final headers = {
      'Authorization': token,
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> body = {
      'test_id': testId
    };

    final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(body));
    return response;
  }

  // Запрос на получение вопроса по id
  static Future<http.Response> getQuestion(int questionId, String token) async {
    const url = '${ApiConfiguration.baseUrl}:${ApiConfiguration.port}/test/getQuestion';
    final headers = {
      'Authorization': token,
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> body = {
      'question_id': questionId
    };

    final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(body));
    return response;
  }
}

//'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMX0.00KV-iWi85eL-CZC4w5Ma2r0_dMw8ohjbjDkStIIXfQ'