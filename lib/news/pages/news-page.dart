import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:finflex/api/news-api.dart';
import 'package:finflex/handles/data-widgets/profile-data-widget.dart';
import 'package:finflex/news/dto/news-dto.dart';
import 'package:finflex/profile/dto/profile-app-data.dart';
import 'package:finflex/styles/text-styles.dart';
import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  Future<List<NewsDTO>> loadNews(ProfileData profileData) async {
    var token = profileData.token!;

    var request = await NewsApiService.GetNews(token);
    List<dynamic> rawNewsList = json.decode(request.body);
    List<NewsDTO> newsList = [];
    for (int i = 0; i < rawNewsList.length; i++) {
      newsList.add(NewsDTO.fromJson(rawNewsList[i]));
    }

    return newsList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadNews(AppProcessDataProvider.of(context)!.profileData),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Ошибка ${snapshot.error}');
          } else {
                return ListView.builder(

                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      NewsCard(
                          newsData: snapshot.data![index]),
                      SizedBox(height: 10)
                    ],
                  );
                });
          }
        });
  }


}

class NewsCard extends StatelessWidget {
  final NewsDTO newsData;
  const NewsCard(
      {super.key, required this.newsData});

  @override
  Widget build(BuildContext context) {
    
    return Card(
        color: Colors.blue,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(40),
          side: BorderSide(width: 2)
        ),
        child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(newsData.date, style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: 10),
                Text(newsData.title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                CachedNetworkImage(
                  imageUrl: newsData.imageSource,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  imageBuilder: (context, imageProvider){
                    return Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 2),
                        image: DecorationImage(image: imageProvider, fit: BoxFit.fitWidth)
                      )
                      
                    );
                  }),
                  const SizedBox(height: 10),
                Text(newsData.text, style: Theme.of(context).textTheme.bodyMedium)
              ],
            )));
  }
}