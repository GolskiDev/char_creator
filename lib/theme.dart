import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final isDarkModeEnabledProvider = StateProvider<bool>(
  (ref) => true,
);

class LightColorScheme {
  final richBrown = const Color(0xFF6D4C41);
  final mutedOliveGreen = const Color(0xFF556B2F);
  final burgundy = const Color(0xFFA52A2A);
  final burntOrange = const Color(0xFFD2691E);
  final darkGrey = const Color(0xFF2F4F4F);
  final beige3 = const Color.fromARGB(255, 248, 236, 210);

  ColorScheme get colorScheme => ColorScheme.fromSeed(
        dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        seedColor: LightColorScheme().burgundy,
        secondary: LightColorScheme().burntOrange,
        tertiary: LightColorScheme().mutedOliveGreen,
        surface: LightColorScheme().beige3,
      );
}

class DarkColorScheme {
  ColorScheme get colorScheme => ColorScheme.fromSeed(
        dynamicSchemeVariant: DynamicSchemeVariant.content,
        brightness: Brightness.dark,
        seedColor: Color.fromARGB(255, 99, 98, 98),
        surface: Color.fromARGB(255, 13, 13, 18),
      );
}

class AppTheme {
  TextStyle get font => GoogleFonts.crimsonText();
  static double get borderRadius => 8;
  themeData({
    required bool isDarkMode,
  }) {
    final colorScheme = isDarkMode
        ? DarkColorScheme().colorScheme
        : LightColorScheme().colorScheme;
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      fontFamily: font.fontFamily,
      // visualDensity: VisualDensity(
      //   horizontal: VisualDensity.minimumDensity,
      //   vertical: VisualDensity.minimumDensity,
      // ),
      cardTheme: CardThemeData(
        elevation: 4,
        margin: EdgeInsets.zero,
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        floatingLabelAlignment: FloatingLabelAlignment.center,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                borderRadius,
              ),
            ),
          ),
        ),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius,
          ),
          side: BorderSide.none,
        ),
        expandedAlignment: Alignment.topLeft,
      ),
    );
  }
}
