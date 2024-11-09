import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Colors2 {
  final richBrown = const Color(0xFF6D4C41);
  final mutedOliveGreen = const Color(0xFF556B2F);
  final burgundy = const Color(0xFFA52A2A);
  final burntOrange = const Color(0xFFD2691E);
  final darkGrey = const Color(0xFF2F4F4F);
  final beige3 = const Color.fromARGB(255, 248, 236, 210);
}

class AppTheme {
  TextStyle get font => GoogleFonts.crimsonText();
  get themeData => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
          seedColor: Colors2().burgundy,
          secondary: Colors2().burntOrange,
          tertiary: Colors2().mutedOliveGreen,
          surface: Colors2().beige3,
        ),
        fontFamily: font.fontFamily,
      );
}
