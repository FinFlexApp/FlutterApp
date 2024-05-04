import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:finflex/api/auth-api.dart';
import 'package:finflex/api/profile-api.dart';
import 'package:finflex/auth/pages/welcome-page.dart';
import 'package:finflex/handles/data-widgets/profile-data-widget.dart';
import 'package:finflex/profile/dto/profile-app-data.dart';
import 'package:finflex/profile/dto/profile-dto.dart';
import 'package:finflex/profile/profile-handles/profile-prefs-handlers.dart';
import 'package:finflex/styles/button-styles.dart';
import 'package:finflex/styles/decorations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfilePage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    Future<ProfileDTO> loadProfileData(ProfileData profileData) async {
      var userId = profileData.userId!;
      var token = profileData.token!;


      var request = await ProfileApiService.GetProfileData(userId, token);
      var profileWidgetData = ProfileDTO.fromJson(json.decode(request.body));

      return profileWidgetData;
    }


    return FutureBuilder(future: loadProfileData(AppProcessDataProvider.of(context)!.profileData), builder: (context, snapshot){
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

  void exitProfile(BuildContext context){
    ProfilePrefs.setPrefsProfileData(ProfileData(token: null, userId: null));
    Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => WelcomePage()),
          );
  }

  void openChangePasswordForm(BuildContext context){
    showDialog(
      context: context,
      builder: (context) => ChangePasswordForm()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              CachedNetworkImage(
                height: 150,
                width: 150,
                  imageUrl: profileData.imageSource,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  imageBuilder: (context, imageProvider){
                    return Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(image: imageProvider, fit: BoxFit.fitWidth)
                      )
                      
                    );
                  }),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(profileData.firstName),
                    Text(profileData.surName),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(30)))),
                      child: Row(
                        children: [
                          Text(profileData.score.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge),
                          SizedBox(width: 10),
                          Image.asset('assets/icons/crown-icon.png')
                        ],
                      ),
                    ),
                  ]
                )
              )
            ]
          ),
        ),
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              ElevatedButton(
                style: ButtonStyles.mainButtonStyle,
                onPressed: (){ openChangePasswordForm(context); },
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text("Сменить пароль"),
                )
                ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyles.mainButtonStyle,
                onPressed: (){exitProfile(context);},
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text("Выйти из аккаунта"),
                )
                ),
            ],
          ),
        ),
      ],
    );
  }

}

class ChangePasswordForm extends StatefulWidget{
  const ChangePasswordForm({super.key});

  @override
  State<StatefulWidget> createState() => _changePasswordState();
}

class _changePasswordState extends State<ChangePasswordForm>{
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  bool hiddenOldPassword = true;
  bool hiddenNewPassword = true;

  bool validationFailed = false;
  

  Future<bool> changePassword(String oldPassword, String newPassword, ProfileData profileData) async{
    var token = profileData.token!;
    var userId = profileData.userId!;

    var request = await ProfileApiService.ChangePassword(oldPassword, newPassword, userId, token);
    var result = json.decode(request.body);

    return result['check'];
  }

  void changePasswordHandler(String oldPassword, String newPassword, ProfileData profileData, BuildContext context) async{
    var result = await changePassword(oldPassword, newPassword, profileData);

    if(result){
      validationFailed = false;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Пароль изменен!")));
    }
    else{
      setState(() {
        validationFailed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 300,
        width: 400,
        child: Column(
          children: [
            Expanded(
              child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: oldPasswordController,
                        decoration: CustomDecorations.MainInputDecoration('Старый пароль'),
                        obscureText: hiddenOldPassword,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: (){
                      setState(() {
                        hiddenOldPassword = !hiddenOldPassword;
                      });
                      },
                      child: hiddenOldPassword ? Image.asset('assets/icons/bot-nav-icon.png') : Image.asset('assets/icons/crown-icon.png')
                      )
                  ],
              ),
            ),
            Expanded(
              child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: newPasswordController,
                        decoration: CustomDecorations.MainInputDecoration('Новый пароль'),
                        obscureText: hiddenNewPassword,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: (){
                      setState(() {
                        hiddenNewPassword = !hiddenNewPassword;
                      });
                      },
                      child: hiddenNewPassword ? Image.asset('assets/icons/bot-nav-icon.png') : Image.asset('assets/icons/crown-icon.png')
                      )
                  ],
              ),
            ),
      
            ElevatedButton(
                  style: ButtonStyles.mainButtonStyle,
                  onPressed: (){ changePasswordHandler(oldPasswordController.text, newPasswordController.text, AppProcessDataProvider.of(context)!.profileData, context); },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text("Сменить пароль"),
                  )
                  ),
          ],
        ),
      ),
    );
  }

}