import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Brand Colors (Dark Theme)
  static const Color bgDark = Color(0xFF09090B); // Dark graphite
  static const Color surfaceDark = Color(0xFF141417); // Elevated surface
  static const Color cardDark = Color(0xFF1C1C21); // Card background
  static const Color borderDark = Color(0xFF27272A); // Neutral borders
  static const Color textPrimaryDark = Color(0xFFFAFAFA); // Off-white text
  static const Color textSecondaryDark = Color(0xFFA1A1AA); // Zinc-400
  static const Color textMutedDark = Color(0xFF52525B); // Zinc-600

  // Brand Colors (Light Theme)
  static const Color bgLight = Color(0xFFFAFAFA); // Crisp white bg
  static const Color surfaceLight = Color(0xFFFFFFFF); // Pure white elevated
  static const Color cardLight = Color(0xFFF4F4F5); // Light zinc surface
  static const Color borderLight = Color(0xFFE4E4E7); // Light zinc border
  static const Color textPrimaryLight = Color(0xFF09090B); // Dark slate text
  static const Color textSecondaryLight = Color(0xFF71717A); // Zinc-500
  static const Color textMutedLight = Color(0xFFA1A1AA); // Zinc-400

  // Accents
  static const Color accentPurple = Color(0xFF8B5CF6); // Deep purple
  static const Color accentIndigo = Color(0xFF6366F1); // Indigo
  static const Color accentCyan = Color(0xFF06B6D4); // Cyan glow
  static const Color accentPink = Color(0xFFEC4899); // Pink highlight
  
  // Gradients
  static const List<Color> premiumGrad = [accentPurple, accentIndigo];
  static const List<Color> cyanPurpleGrad = [accentCyan, accentPurple];
  static const List<Color> glowGrad = [accentPurple, Color(0xFF3B82F6), accentCyan];
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.accentPurple,
      scaffoldBackgroundColor: AppColors.bgLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.accentPurple,
        secondary: AppColors.accentIndigo,
        tertiary: AppColors.accentCyan,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimaryLight,
        background: AppColors.bgLight,
        onBackground: AppColors.textPrimaryLight,
        outline: AppColors.borderLight,
      ),
      dividerColor: AppColors.borderLight,
      textTheme: _buildTextTheme(AppColors.textPrimaryLight, AppColors.textSecondaryLight),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimaryLight),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentPurple,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimaryLight,
          side: const BorderSide(color: AppColors.borderLight, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardLight,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accentPurple, width: 2),
        ),
        labelStyle: TextStyle(color: AppColors.textSecondaryLight),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.accentPurple,
      scaffoldBackgroundColor: AppColors.bgDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentPurple,
        secondary: AppColors.accentIndigo,
        tertiary: AppColors.accentCyan,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
        background: AppColors.bgDark,
        onBackground: AppColors.textPrimaryDark,
        outline: AppColors.borderDark,
      ),
      dividerColor: AppColors.borderDark,
      textTheme: _buildTextTheme(AppColors.textPrimaryDark, AppColors.textSecondaryDark),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimaryDark),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentPurple,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimaryDark,
          side: const BorderSide(color: AppColors.borderDark, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardDark,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accentPurple, width: 2),
        ),
        labelStyle: TextStyle(color: AppColors.textSecondaryDark),
      ),
    );
  }

  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: GoogleFonts.plusJakartaSans(
        color: primary,
        fontWeight: FontWeight.w800,
        fontSize: 54,
        letterSpacing: -1.5,
      ),
      displayMedium: GoogleFonts.plusJakartaSans(
        color: primary,
        fontWeight: FontWeight.w800,
        fontSize: 38,
        letterSpacing: -1.0,
      ),
      displaySmall: GoogleFonts.plusJakartaSans(
        color: primary,
        fontWeight: FontWeight.w700,
        fontSize: 28,
        letterSpacing: -0.5,
      ),
      headlineLarge: GoogleFonts.plusJakartaSans(
        color: primary,
        fontWeight: FontWeight.w700,
        fontSize: 24,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        color: primary,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        color: primary,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      bodyLarge: GoogleFonts.inter(
        color: primary,
        fontSize: 16,
        height: 1.6,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: GoogleFonts.inter(
        color: secondary,
        fontSize: 14,
        height: 1.6,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: GoogleFonts.inter(
        color: secondary.withOpacity(0.8),
        fontSize: 12,
        height: 1.5,
      ),
    );
  }
}