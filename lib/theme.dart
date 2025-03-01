import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  double get borderRadius => 8;
  get themeData => ThemeData(
        useMaterial3: true,
        colorScheme: DarkColorScheme().colorScheme,
        fontFamily: font.fontFamily,
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.zero,
        ),
      );
}
