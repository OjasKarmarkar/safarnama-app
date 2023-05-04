import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget themeWrapper({required Widget child}) {

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarColor: Colors.white,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark),
        child: child);
  }

SystemUiOverlayStyle appBarStyle() {
  return  const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor:  Colors.white,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness : Brightness.dark,
      statusBarIconBrightness:  Brightness.dark);
}