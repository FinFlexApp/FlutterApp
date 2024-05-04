import 'package:finflex/profile/dto/profile-app-data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePrefsKeys{
  static const String userIdKey = 'userId';
  static const String tokenKey = 'token';
}

class ProfilePrefs{
  static Future<ProfileData> getPrefsProfileData() async{
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    String? token = sharedPrefs.getString(ProfilePrefsKeys.tokenKey);
    int? userId = sharedPrefs.getInt(ProfilePrefsKeys.userIdKey);

    return ProfileData(token: token, userId: userId);
  }

  static Future<void> setPrefsProfileData(ProfileData data) async{
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

    if(data.token == null || data.userId == null){
      sharedPrefs.remove(ProfilePrefsKeys.tokenKey);
      sharedPrefs.remove(ProfilePrefsKeys.userIdKey);
      return;
    }
    
    sharedPrefs.setString(ProfilePrefsKeys.tokenKey, data.token!);
    sharedPrefs.setInt(ProfilePrefsKeys.userIdKey, data.userId!);
  }
}