import 'package:finflex/api/api-config.dart';
import 'package:http/http.dart' as http;

class NewsApiService{
  static Future<http.Response> GetNews(String token) async {
    const url = '${ApiConfiguration.baseUrl}:${ApiConfiguration.port}/news';
    final headers = {
      'Authorization': token,
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(url), headers: headers);
    return response;
  }
}