import 'dart:convert';

import 'package:finflex/api/profile-api.dart';
import 'package:finflex/profile/dto/profile-dto.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    Future<ProfileDTO> loadProfileData(int userId, String token) async {
      var request = await ProfileApiService.GetProfileData(userId, token);
      var profileData = ProfileDTO.fromJson(json.decode(request.body));

      return profileData;
    }


    return FutureBuilder(future: loadProfileData(11, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMX0.00KV-iWi85eL-CZC4w5Ma2r0_dMw8ohjbjDkStIIXfQ'), builder: (context, snapshot){
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      }
      else{
        return ProfileInfoWidget(profileData: snapshot.data!);
      }
    });
  }
}

class ProfileInfoWidget extends StatelessWidget{
  final ProfileDTO profileData;

  const ProfileInfoWidget({super.key, required this.profileData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(profileData.firstName),
        Text(profileData.surName),
        Text(profileData.score.toString())
      ],
    );
  }

}