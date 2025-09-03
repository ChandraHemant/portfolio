import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary colors with improved palette
  static final Color primaryColorLight = Color(0xFF2563EB); // Brighter blue
  static final Color primaryColorDark = Color(0xFF60A5FA);  // Lighter blue for dark mode

  // Background colors with subtle gradients
  static final Color backgroundColorLight = Colors.white;
  static final Color backgroundColorDark = Color(0xFF121827); // Slightly bluish dark

  // Text colors with better contrast
  static final Color textColorLight = Color(0xFF1E293B); // Slate-800
  static final Color textColorDark = Color(0xFFF1F5F9);  // Slate-100

  // Secondary accent colors
  static final Color secondaryColorLight = Color(0xFFEF4444); // Red-500
  static final Color secondaryColorDark = Color(0xFFFCA5A5);  // Red-300

  // Additional colors for UI elements
  static final Color surfaceColorLight = Color(0xFFF8FAFC); // Slate-50
  static final Color surfaceColorDark = Color(0xFF1E293B);  // Slate-800

  static final Color successColor = Color(0xFF22C55E); // Green-500
  static final Color warningColor = Color(0xFFF59E0B); // Amber-500

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColorLight,
    scaffoldBackgroundColor: backgroundColorLight,
    fontFamily: GoogleFonts.inter().fontFamily,
    colorScheme: ColorScheme.light(
      primary: primaryColorLight,
      secondary: secondaryColorLight,
      background: backgroundColorLight,
      surface: surfaceColorLight,
      onSurface: textColorLight,
      onBackground: textColorLight,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.inter(
        color: textColorLight,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
      displayMedium: GoogleFonts.inter(
        color: textColorLight,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
      displaySmall: GoogleFonts.inter(
        color: textColorLight,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
      bodyLarge: GoogleFonts.inter(color: textColorLight, height: 1.6),
      bodyMedium: GoogleFonts.inter(color: textColorLight, height: 1.6),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundColorLight,
      elevation: 0,
      iconTheme: IconThemeData(color: textColorLight),
      titleTextStyle: GoogleFonts.inter(
          color: textColorLight,
          fontSize: 20,
          fontWeight: FontWeight.bold
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColorLight,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColorLight,
        side: BorderSide(color: primaryColorLight, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColorLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColorLight, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade200,
      thickness: 1,
      space: 32,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColorDark,
    scaffoldBackgroundColor: backgroundColorDark,
    fontFamily: GoogleFonts.inter().fontFamily,
    colorScheme: ColorScheme.dark(
      primary: primaryColorDark,
      secondary: secondaryColorDark,
      background: backgroundColorDark,
      surface: surfaceColorDark,
      onSurface: textColorDark,
      onBackground: textColorDark,
      onPrimary: Color(0xFF0F172A), // Slate-900
      onSecondary: Color(0xFF0F172A), // Slate-900
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.inter(
        color: textColorDark,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
      displayMedium: GoogleFonts.inter(
        color: textColorDark,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
      displaySmall: GoogleFonts.inter(
        color: textColorDark,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
      bodyLarge: GoogleFonts.inter(color: textColorDark, height: 1.6),
      bodyMedium: GoogleFonts.inter(color: textColorDark, height: 1.6),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundColorDark,
      elevation: 0,
      iconTheme: IconThemeData(color: textColorDark),
      titleTextStyle: GoogleFonts.inter(
          color: textColorDark,
          fontSize: 20,
          fontWeight: FontWeight.bold
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColorDark,
        foregroundColor: Color(0xFF0F172A), // Slate-900
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColorDark,
        side: BorderSide(color: primaryColorDark, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColorDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade800),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade800),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColorDark, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade800,
      thickness: 1,
      space: 32,
    ),
  );
}