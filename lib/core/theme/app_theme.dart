import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:b_risk/core/theme/risk_colors.dart';

/// Material 3 styled toward M3 Expressive: vibrant color, Google Sans Flex with
/// emphasized weights, and the larger expressive corner radii.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => build(Brightness.light);
  static ThemeData get darkTheme => build(Brightness.dark);

  /// Tests pass their own [font]: google_fonts can't download inside flutter test.
  static ThemeData build(
    Brightness brightness, {
    TextTheme Function(TextTheme) font = GoogleFonts.googleSansFlexTextTheme,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: RiskColors.primary,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.tonalSpot,
    );
    final base = ThemeData(colorScheme: scheme);
    final text = font(base.textTheme);

    return base.copyWith(
      textTheme: text.copyWith(
        displayMedium: text.displayMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -1),
        displaySmall: text.displaySmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5),
        headlineLarge: text.headlineLarge?.copyWith(fontWeight: FontWeight.w800),
        headlineMedium: text.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
        headlineSmall: text.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        titleLarge: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        titleSmall: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        labelLarge: text.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(28)),
        ),
      ),
      chipTheme: const ChipThemeData(shape: StadiumBorder()),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: scheme.surfaceContainer,
        labelTextStyle: WidgetStatePropertyAll(text.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }
}
