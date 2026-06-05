import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:b_risk/core/theme/risk_colors.dart';

class AppTheme {
  AppTheme._();

  // ── Light Theme ────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.interTextTheme(ThemeData.light().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: RiskColors.primary,
        brightness: Brightness.light,
        primary: RiskColors.primary,
        onPrimary: Colors.white,
        surface: RiskColors.surfaceLight,
        onSurface: RiskColors.textPrimaryLight,
        surfaceContainerHighest: RiskColors.surfaceMid,
        outline: RiskColors.borderLight,
      ),
      scaffoldBackgroundColor: RiskColors.surfaceLight,
      textTheme: textTheme.copyWith(
        headlineLarge: textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: RiskColors.textPrimaryLight,
          letterSpacing: -0.5,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: RiskColors.textPrimaryLight,
          letterSpacing: -0.3,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: RiskColors.textPrimaryLight,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: RiskColors.textPrimaryLight,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          color: RiskColors.textPrimaryLight,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          color: RiskColors.textSecondaryLight,
        ),
        bodySmall: textTheme.bodySmall?.copyWith(
          color: RiskColors.textTertiaryLight,
        ),
        labelLarge: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
        labelMedium: textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: RiskColors.cardLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: RiskColors.borderLight, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        side: BorderSide.none,
        labelStyle: textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: RiskColors.cardLight,
        foregroundColor: RiskColors.primary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: RiskColors.borderLight,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  // ── Dark Theme ─────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: RiskColors.primary,
        brightness: Brightness.dark,
        primary: RiskColors.primaryLight,
        onPrimary: RiskColors.surfaceDark,
        surface: RiskColors.surfaceDark,
        onSurface: RiskColors.textPrimaryDark,
        surfaceContainerHighest: RiskColors.surfaceDarkMid,
        outline: RiskColors.borderDark,
      ),
      scaffoldBackgroundColor: RiskColors.surfaceDark,
      textTheme: textTheme.copyWith(
        headlineLarge: textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: RiskColors.textPrimaryDark,
          letterSpacing: -0.5,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: RiskColors.textPrimaryDark,
          letterSpacing: -0.3,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: RiskColors.textPrimaryDark,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: RiskColors.textPrimaryDark,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          color: RiskColors.textPrimaryDark,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          color: RiskColors.textSecondaryDark,
        ),
        bodySmall: textTheme.bodySmall?.copyWith(
          color: RiskColors.textTertiaryDark,
        ),
        labelLarge: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
        labelMedium: textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: RiskColors.cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: RiskColors.borderDark, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        side: BorderSide.none,
        labelStyle: textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: RiskColors.cardDark,
        foregroundColor: RiskColors.primaryLight,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: RiskColors.borderDark,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
