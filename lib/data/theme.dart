import 'package:flutter/material.dart';

class ThemeManager {
  static ThemeData lightTheme = ThemeData(
    // textTheme: TextTheme(button: TextStyle(color: Colors.white)),
    iconTheme: const IconThemeData(),
    backgroundColor: Colors.grey,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xFF454587),
        textStyle: TextStyle(color: Colors.white),
        // backgroundColor: Colors.white,
        // padding: const EdgeInsets.all(35),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ), // Set the text color to white
      ),
    ),
  );
}