import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:speezu/core/assets/font_family.dart';

enum AppThemeMode { light, dark }

class AppTheme {
  static const Color mainColor = Color(0xFF01035E);
  static const Color mainDarkColor = Color(0xFF01035E);
  static const Color secondColor = Color(0xFF98CC33);
  static const Color secondDarkColor = Color(0xFF98CC33);
  static const Color accentColor = Color(0xFF8C98A8);
  static const Color accentDarkColor = Color(0xFF9999AA);
  static const Color scaffoldColor = Color(0xFFFAFAFA);
  static const Color scaffoldDarkColor = Color(0xFF2C2C2C);

  // Additional colors for comprehensive theming
  static const Color textPrimaryLight = Color(0xFF000000);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color errorColor = Color(0xFFB00020);
  static const Color successColor = Color(0xFF2ECC71);
  static const Color warningColor = Color(0xFFFFA726);

  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: FontFamily.fontsPoppinsRegular,
      brightness: Brightness.light,
      hintColor: AppTheme.textPrimaryDark,
      shadowColor: Colors.grey.withValues(alpha: 0.5),
      primaryColor: mainColor,
      primaryColorDark: mainDarkColor,
      scaffoldBackgroundColor: scaffoldColor,
      colorScheme: ColorScheme.light(
        outline: accentColor,
        primary: mainColor,
        secondary: secondColor,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        surface: scaffoldColor,
        onSurface: textPrimaryLight,
        error: errorColor,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimaryLight,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textPrimaryLight,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textSecondaryLight,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondColor,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondColor,
        foregroundColor: Colors.black,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: mainColor),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dividerColor: accentColor,
      iconTheme: IconThemeData(color: textPrimaryLight),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scaffoldColor,
        selectedItemColor: mainColor,
        unselectedItemColor: textSecondaryLight,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: FontFamily.fontsPoppinsRegular,
      hintColor: AppTheme.textPrimaryDark,
      shadowColor: Colors.grey.withValues(alpha: 0.5),
      primaryColor: mainDarkColor,
      primaryColorDark: mainDarkColor,
      scaffoldBackgroundColor: scaffoldDarkColor,
      colorScheme: ColorScheme.dark(
        primary: mainDarkColor,
        secondary: secondDarkColor,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        surface: scaffoldDarkColor,
        onSurface: textPrimaryDark,
        outline: accentDarkColor,

        error: errorColor,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimaryDark,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textPrimaryDark,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textSecondaryDark,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: mainDarkColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondDarkColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondDarkColor,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardTheme(
        color: Color(0xFF3A3A3A),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: mainDarkColor),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dividerColor: accentDarkColor,
      iconTheme: IconThemeData(color: textPrimaryDark),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scaffoldDarkColor,
        selectedItemColor: mainDarkColor,
        unselectedItemColor: textSecondaryDark,
      ),
    );
  }
}