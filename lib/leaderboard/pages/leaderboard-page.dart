import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:finflex/api/leaderboard-api.dart';
import 'package:finflex/api/news-api.dart';
import 'package:finflex/handles/data-widgets/profile-data-widget.dart';
import 'package:finflex/leaderboard/dto/leaderboard-dto.dart';
import 'package:finflex/news/dto/news-dto.dart';
import 'package:finflex/profile/dto/profile-app-data.dart';
import 'package:finflex/styles/colors.dart';
import 'package:finflex/styles/text-styles.dart';
import 'package:flutter/material.dart';

class LeaderBoardPage extends StatelessWidget {
  const LeaderBoardPage({super.key});

  Future<List<LeaderDTO>> loadLeaders(int count, ProfileData profileData) async {
    var token = profileData.token!;

    var request = await LeaderboardApiService.GetLeaders(count, token);
    List<dynamic> rawLeadersList = json.decode(request.body);
    List<LeaderDTO> leadersList = [];
    for (int i = 0; i < rawLeadersList.length; i++) {
      leadersList.add(LeaderDTO.fromJson(rawLeadersList[i]));
    }

    return leadersList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadLeaders(5, AppProcessDataProvider.of(context)!.profileData),
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
                      LeaderCard(
                          index: index, leaderData: snapshot.data![index]),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: const Divider(
                          color: ColorStyles
                              .leaderDividerColor, // Цвет разделителя
                          thickness: 2.0, // Толщина разделителя
                        ),
                      ),
                    ],
                  );
                });
          }
        });
  }
}

class LeaderCard extends StatelessWidget {
  final LeaderDTO leaderData;
  final int index;

  const LeaderCard({super.key, required this.index, required this.leaderData});

  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        return Container(
          padding: EdgeInsets.all(10),
          decoration: ShapeDecoration(
              color: ColorStyles.leaderFirstCardColor,
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(40))),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text((index + 1).toString(),
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(color: ColorStyles.leaderFirstTextColor)),
              ),
              CachedNetworkImage(
                  imageUrl: leaderData.imageSource,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  imageBuilder: (context, imageProvider) {
                    return Container(
                        height: 125,
                        width: 125,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.fitWidth)));
                  }),
              SizedBox(width: 10),
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${leaderData.surName} ${leaderData.firstName}',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(color: ColorStyles.leaderFirstTextColor)),
                    Container(
                        padding: EdgeInsets.all(10),
                        decoration: ShapeDecoration(
                            color: ColorStyles.leaderFirstTextColor,
                            shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(40))),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30)))),
                              child: Row(
                                children: [
                                  Text(leaderData.score.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge),
                                  SizedBox(width: 10),
                                  Image.asset('assets/icons/crown-icon.png')
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30)))),
                              child: Row(
                                children: [
                                  Text(leaderData.testsPassed.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge),
                                  SizedBox(width: 10),
                                  Image.asset('assets/icons/test-icon.png')
                                ],
                              ),
                            )
                          ],
                        ))
                  ],
                ),
              )
            ],
          ),
        );
      case 1:
        return Container(
          padding: EdgeInsets.all(10),
          decoration: ShapeDecoration(
              color: ColorStyles.leaderSecondCardColor,
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(40))),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text((index + 1).toString(),
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(color: ColorStyles.leaderSecondTextColor)),
              ),
              CachedNetworkImage(
                  imageUrl: leaderData.imageSource,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  imageBuilder: (context, imageProvider) {
                    return Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.fitWidth)));
                  }),
              SizedBox(width: 10),
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${leaderData.surName} ${leaderData.firstName}',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                color: ColorStyles.leaderSecondTextColor)),
                    Container(
                        decoration: ShapeDecoration(
                            color: ColorStyles.leaderSecondTextColor,
                            shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(40))),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30)))),
                              child: Row(
                                children: [
                                  Text(leaderData.score.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge),
                                  SizedBox(width: 10),
                                  Image.asset('assets/icons/crown-icon.png')
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30)))),
                              child: Row(
                                children: [
                                  Text(leaderData.testsPassed.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge),
                                  SizedBox(width: 10),
                                  Image.asset('assets/icons/test-icon.png')
                                ],
                              ),
                            )
                          ],
                        ))
                  ],
                ),
              )
            ],
          ),
        );
      case 2:
        return Container(
          padding: EdgeInsets.all(10),
          decoration: ShapeDecoration(
              color: ColorStyles.leaderThirdCardColor,
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(40))),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text((index + 1).toString(),
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(color: ColorStyles.leaderThirdTextColor)),
              ),
              CachedNetworkImage(
                  imageUrl: leaderData.imageSource,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  imageBuilder: (context, imageProvider) {
                    return Container(
                        height: 75,
                        width: 75,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.fitWidth)));
                  }),
              SizedBox(width: 10),
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${leaderData.surName} ${leaderData.firstName}',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(color: ColorStyles.leaderThirdTextColor)),
                    Container(
                        decoration: ShapeDecoration(
                            color: ColorStyles.leaderThirdTextColor,
                            shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(40))),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30)))),
                              child: Row(
                                children: [
                                  Text(leaderData.score.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge),
                                  SizedBox(width: 10),
                                  Image.asset('assets/icons/crown-icon.png')
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30)))),
                              child: Row(
                                children: [
                                  Text(leaderData.testsPassed.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge),
                                  SizedBox(width: 10),
                                  Image.asset('assets/icons/test-icon.png')
                                ],
                              ),
                            )
                          ],
                        ))
                  ],
                ),
              )
            ],
          ),
        );

      default:
        return Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text((index + 1).toString()),
                Text('${leaderData.surName} ${leaderData.firstName}'),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: ContinuousRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)))),
                      child: Row(
                        children: [
                          Text(leaderData.score.toString(),
                              style: Theme.of(context).textTheme.displayLarge),
                          SizedBox(width: 10),
                          Image.asset('assets/icons/crown-icon.png')
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: ContinuousRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)))),
                      child: Row(
                        children: [
                          Text(leaderData.testsPassed.toString(),
                              style: Theme.of(context).textTheme.displayLarge),
                          SizedBox(width: 10),
                          Image.asset('assets/icons/test-icon.png')
                        ],
                      ),
                    )
                  ],
                )
              ],
            ));
    }
  }
}
