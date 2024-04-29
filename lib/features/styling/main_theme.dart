import 'package:flutter/material.dart';

final ThemeData mainTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSwatch(
    brightness: Brightness.light,
    primarySwatch: Colors.brown,
    cardColor: Colors.brown.shade100,
    backgroundColor: Colors.brown.shade50,
    accentColor: Colors.brown.shade300,
    errorColor: Colors.red.shade400,
  ),
);
