import 'package:flutter/material.dart';

/// Design tokens from the Pause prototype. Dark is primary (the urge often hits
/// at night); light is supported. Full styling (fonts, gradients, the orb) lands
/// in Slice 2 — this is the minimal palette the skeleton needs.
class PauseColors {
  // Dark (primary)
  static const bg = Color(0xFF0E1A1E);
  static const panel = Color(0xFF16252A);
  static const text = Color(0xFFEAD7B8);
  static const amber = Color(0xFFD4A875);

  // Light
  static const lightBg = Color(0xFFF3EBDD);
  static const lightPanel = Color(0xFFFBF6EC);
  static const lightText = Color(0xFF352A1A);
  static const lightAmber = Color(0xFFB07636);
}

class PauseTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: PauseColors.bg,
    colorScheme: const ColorScheme.dark(
      surface: PauseColors.bg,
      primary: PauseColors.amber,
      onPrimary: Color(0xFF1A120A),
      onSurface: PauseColors.text,
    ),
  );

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: PauseColors.lightBg,
    colorScheme: const ColorScheme.light(
      surface: PauseColors.lightBg,
      primary: PauseColors.lightAmber,
      onPrimary: Colors.white,
      onSurface: PauseColors.lightText,
    ),
  );
}
