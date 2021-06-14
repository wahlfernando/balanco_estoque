import 'package:flutter/material.dart';

const verde = Colors.green;
const kLightGrey = const Color(0xFFE8E8E8);
const kDarkGrey = const Color(0xFF303030);

ThemeData buildTheme(Color accentColor, bool isDark)  {

  final ThemeData base = isDark ? ThemeData.dark() : ThemeData.light();

  final Color primaryColor = isDark ? kDarkGrey : accentColor;

  return base.copyWith(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.green,
    appBarTheme: const AppBarTheme(elevation: 0),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}