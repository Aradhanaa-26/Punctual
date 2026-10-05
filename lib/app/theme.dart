import 'package:flutter/material.dart';

class PunctualColors {
  static const background = Color(0xFF15131A);
  static const secondaryBackground = Color(0xFF1B1821);
  static const section = Color(0xFF211D27);
  static const card = Color(0xFF24202B);
  static const elevatedCard = Color(0xFF2B2633);

  static const primary = Color(0xFF6F4A7D);
  static const deepAccent = Color(0xFF563565);
  static const highlight = Color(0xFF8B649C);
  static const softHighlight = Color(0xFFA982B5);

  static const dustyRose = Color(0xFFA87891);
  static const softRose = Color(0xFFBC8FA5);

  static const white = Color(0xFFFFFFFF);
  static const primaryText = Color(0xFFF1EDF4);
  static const secondaryText = Color(0xFFB7ACBD);
  static const mutedText = Color(0xFF817987);
  static const disabled = Color(0xFF625C67);

  static const border = Color(0xFF463A4E);

  static const healthy = Color(0xFF8BB99C);
  static const warning = Color(0xFFD0A45F);
  static const critical = Color(0xFFC97878);

  static const progressTrack = Color(0xFF403846);
}

class PunctualTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: PunctualColors.background,
      primaryColor: PunctualColors.primary,

      colorScheme: const ColorScheme.dark(
        primary: PunctualColors.primary,
        secondary: PunctualColors.highlight,
        surface: PunctualColors.card,
        error: PunctualColors.critical,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: PunctualColors.background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: PunctualColors.primaryText,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: PunctualColors.primaryText,
        ),
      ),

      cardTheme: const CardThemeData(
        color: PunctualColors.card,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PunctualColors.card,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: PunctualColors.border,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: PunctualColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: PunctualColors.primary,
            width: 1.5,
          ),
        ),
        hintStyle: const TextStyle(
          color: PunctualColors.mutedText,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: PunctualColors.primary,
          foregroundColor: PunctualColors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: PunctualColors.primaryText,
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          color: PunctualColors.primaryText,
          fontSize: 26,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          color: PunctualColors.primaryText,
          fontSize: 21,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: PunctualColors.primaryText,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: PunctualColors.primaryText,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: PunctualColors.secondaryText,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: PunctualColors.mutedText,
          fontSize: 12,
        ),
      ),
    );
  }
}