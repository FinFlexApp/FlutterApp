import 'package:intl/intl.dart';

class NewsDTO{
  final String date;
  final String imageSource;
  final String text;
  final String title;

  NewsDTO({required this.date,
            required this.imageSource,
            required this.text,
            required this.title});

  factory NewsDTO.fromJson(Map<String, dynamic> json) => NewsDTO(
    date: json['date'],
    imageSource: json['preview_src'],
    text: json['text'],
    title: json['title']
  );
}
