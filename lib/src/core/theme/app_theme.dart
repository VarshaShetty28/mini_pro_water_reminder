import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.blue,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: TextTheme(
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),  // Updated from headline1 to headlineLarge
    bodyLarge: TextStyle(fontSize: 16),  // Updated from bodyText1 to bodyLarge
  ),
);
