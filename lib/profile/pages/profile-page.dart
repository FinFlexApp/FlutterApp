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
import 'package:finflex/styles/text-styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('@${profileData.nickname}', style: Theme.of(context).textTheme.labelMedium),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        Text(profileData.firstName, style: Theme.of(context).textTheme.labelLarge),
                        SizedBox(width: 10),
                        Text(profileData.surName, style: Theme.of(context).textTheme.labelLarge),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: CustomDecorations.progressDataDecoration,
                      child: Wrap(
                        children: [
                          Text(profileData.score.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium),
                          SizedBox(width: 10),
                          SvgPicture.asset('assets/icons/crown-icon.svg', height: 25)
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
                style: ButtonStyles.mainButtonStyle.copyWith(backgroundColor: MaterialStatePropertyAll(Colors.red)),
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

  String validationMessage = '';

  bool newPasswordValidated = true;
  bool oldPasswordValidated = true;
  

  Future<bool> changePassword(String oldPassword, String newPassword, ProfileData profileData) async{
    var token = profileData.token!;
    var userId = profileData.userId!;

    var request = await ProfileApiService.ChangePassword(oldPassword, newPassword, userId, token);
    var result = json.decode(request.body);
    if(result['check'] != null)
      return result['check'];
    else return false;
  }

  String validatePasswords(String oldPassword, String newPassword){
    if(oldPassword.isEmpty) return "Ошибка валидации : не введен старый пароль";
    if(oldPassword.length < 8) return "Ошибка валидации : старый пароль содержит менее 8 символов";
    if(newPassword.isEmpty) return "Ошибка валидации : не введен новый пароль";
    if(newPassword.length < 8) return "Ошибка валидации : новый пароль содержит менее 8 символов";

    return '';
  }

  void changePasswordHandler(String oldPassword, String newPassword, ProfileData profileData, BuildContext context) async{
    
    validationMessage = validatePasswords(oldPassword, newPassword);
    if(validationMessage.isNotEmpty) return;

    var result = await changePassword(oldPassword, newPassword, profileData);

    if(result){
      validationMessage = '';
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Пароль изменен!")));
    }
    else{
      setState(() {
        validationMessage = 'Ошибка сервера : введен неверный старый пароль';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: CustomDecorations.modalShapeDecoration,
        padding: EdgeInsets.all(20),
        height: 350,
        width: 400,
        child: Column(
          children: [
            Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: CustomTextThemes.InputTextStyle,
                      controller: oldPasswordController,
                      decoration: CustomDecorations.MainInputDecoration('Старый пароль', oldPasswordValidated),
                      obscureText: hiddenOldPassword,
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyles.visibilityButtonStyle,
                    onPressed: (){
                    setState(() {
                      hiddenOldPassword = !hiddenOldPassword;
                    });
                    },
                    child: hiddenOldPassword ? Icon(Icons.visibility_off) : Icon(Icons.visibility)
                    )
                ],
            ),
            SizedBox(height: 20),
            Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: CustomTextThemes.InputTextStyle,
                      controller: newPasswordController,
                      decoration: CustomDecorations.MainInputDecoration('Новый пароль', newPasswordValidated),
                      obscureText: hiddenNewPassword,
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyles.visibilityButtonStyle,
                    onPressed: (){
                    setState(() {
                      hiddenNewPassword = !hiddenNewPassword;
                    });
                    },
                    child: hiddenNewPassword ? Icon(Icons.visibility_off) : Icon(Icons.visibility)
                    )
                ],
            ),
            SizedBox(height: 10),
            validationMessage.isNotEmpty ? Container(
              padding: EdgeInsets.all(10),
              decoration: CustomDecorations.progressDataDecoration,
              child: Text(validationMessage, style: TextStyle(color: Colors.red),),
            ) : Container(),
            SizedBox(height: 10),
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