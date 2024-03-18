import 'package:flutter/material.dart';

class ThemeManager {
  static ThemeData lightTheme = ThemeData(
    
    iconTheme: const IconThemeData(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xFF454587),
        textStyle: const TextStyle(color: Colors.white),
        
        
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ), 
      ),
    ),
    
  );
}