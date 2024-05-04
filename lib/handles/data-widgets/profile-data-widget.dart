import 'package:finflex/profile/dto/profile-app-data.dart';
import 'package:flutter/material.dart';

class AppProcessDataProvider extends InheritedWidget{
  ProfileData profileData = ProfileData(token: null, userId: null);
  final Widget child;

  AppProcessDataProvider({
    required this.child,
  }) : super(child: child);

  static AppProcessDataProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppProcessDataProvider>();
  }

  @override
  bool updateShouldNotify(AppProcessDataProvider oldWidget) {
    return profileData != oldWidget.profileData;
  }
}