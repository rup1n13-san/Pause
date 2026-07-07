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

  // Dark — breath orb (Slice 1). orbA→orbB is the inner orb's radial gradient
  // (upper-left highlight → edge); glow is the outer halo (50% alpha amber).
  static const orbA = Color(0xFFF0CF99);
  static const orbB = Color(0xFFA67944);
  static const glow = Color(0x80D4A875);

  // Dark — surfaces, lines & chips (Slice 2). Alpha channels are the design's
  // rgba() opacities over the base text/amber colour.
  static const raised = Color(0xFF1C2F35);
  static const muted = Color(0x8CEAD7B8); // text @ 0.55
  static const faint = Color(0x57EAD7B8); // text @ 0.34
  static const line = Color(0x1FEAD7B8); // text @ 0.12
  static const chip = Color(0x0FEAD7B8); // text @ 0.06 (row/chip default)
  static const chipA = Color(0x29D4A875); // amber @ 0.16 (row/chip pressed)

  // Light
  static const lightBg = Color(0xFFF3EBDD);
  static const lightPanel = Color(0xFFFBF6EC);
  static const lightText = Color(0xFF352A1A);
  static const lightAmber = Color(0xFFB07636);

  // Light — breath orb (Slice 1).
  static const lightOrbA = Color(0xFFF3D29A);
  static const lightOrbB = Color(0xFFC4945A);
  static const lightGlow = Color(0x61C9965A);

  // Light — surfaces, lines & chips (Slice 2).
  static const lightRaised = Color(0xFFFFFFFF);
  static const lightMuted = Color(0x9E352A1A); // text @ 0.62
  static const lightFaint = Color(0x6B352A1A); // text @ 0.42
  static const lightLine = Color(0x21352A1A); // text @ 0.13
  static const lightChip = Color(0x0D352A1A); // text @ 0.05
  static const lightChipA = Color(0x29B07636); // amber @ 0.16

  /// Text colour that sits on top of an amber fill (the design hardcodes this,
  /// it is not a theme var). Used by primary buttons and the Home orb label.
  static const onAmber = Color(0xFF1A120A);
}

/// Named text styles for the Pause design. These are static, so tokens that
/// vary by brightness (text/muted/faint colours) are passed in by the call
/// site — same pattern `breath_view.dart` uses for the orb/muted colours:
/// `isDark ? PauseColors.text : PauseColors.lightText`.
class PauseTextStyles {
  const PauseTextStyles._();

  /// Emotional "moment" line — Fraunces italic 300, the ONLY registered
  /// Fraunces style. Size varies per screen (26–30px), so it is a parameter.
  static TextStyle title({required double fontSize, required Color color}) =>
      TextStyle(
        fontFamily: 'Fraunces',
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w300,
        fontSize: fontSize,
        height: 1.2,
        color: color,
      );

  /// Body copy — Nunito 300, relaxed line-height.
  static TextStyle body({required Color color, double fontSize = 13}) =>
      TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w300,
        fontSize: fontSize,
        height: 1.55,
        color: color,
      );

  /// Small meta / data text — DM Mono 400, gently tracked out.
  static TextStyle meta({required Color color, double fontSize = 11}) =>
      TextStyle(
        fontFamily: 'DM Mono',
        fontWeight: FontWeight.w400,
        fontSize: fontSize,
        letterSpacing: 0.4,
        color: color,
      );

  /// Tappable-surface label — Nunito 500 (Feeling chips, Off-ramp rows, the
  /// orb's "tap" label). Size is the one thing that varies between call sites.
  static TextStyle label({required Color color, double fontSize = 15}) =>
      TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w500,
        fontSize: fontSize,
        color: color,
      );
}

class PauseTheme {
  // Shared button geometry (design: ~18px vertical padding, ~14px radius,
  // Nunito). Kept here so every call site is styling-free.
  static const _buttonPadding = EdgeInsets.symmetric(
    vertical: 18,
    horizontal: 24,
  );
  static final _buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(14),
  );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: PauseColors.bg,
        colorScheme: const ColorScheme.dark(
          surface: PauseColors.bg,
          primary: PauseColors.amber,
          onPrimary: PauseColors.onAmber,
          onSurface: PauseColors.text,
        ),
        filledButtonTheme: _filledButtonTheme(PauseColors.amber),
        outlinedButtonTheme: _outlinedButtonTheme(
          border: PauseColors.line,
          foreground: PauseColors.text,
          pressed: PauseColors.amber,
        ),
      );

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: PauseColors.lightBg,
        colorScheme: const ColorScheme.light(
          surface: PauseColors.lightBg,
          primary: PauseColors.lightAmber,
          onPrimary: PauseColors.onAmber,
          onSurface: PauseColors.lightText,
        ),
        filledButtonTheme: _filledButtonTheme(PauseColors.lightAmber),
        outlinedButtonTheme: _outlinedButtonTheme(
          border: PauseColors.lightLine,
          foreground: PauseColors.lightText,
          pressed: PauseColors.lightAmber,
        ),
      );

  /// Primary/filled button: amber fill, dark text, Nunito 600. On press a very
  /// subtle white overlay lightens the fill (M3-idiomatic; no hover on mobile).
  static FilledButtonThemeData _filledButtonTheme(Color fill) =>
      FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(fill),
          foregroundColor: const WidgetStatePropertyAll(PauseColors.onAmber),
          overlayColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.pressed)
                ? Colors.white.withValues(alpha: 0.10)
                : null,
          ),
          elevation: const WidgetStatePropertyAll(0),
          padding: const WidgetStatePropertyAll(_buttonPadding),
          shape: WidgetStatePropertyAll(_buttonShape),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      );

  /// Secondary/outlined button: transparent fill, 1px line border, text colour,
  /// Nunito 500. Border brightens to amber on press.
  static OutlinedButtonThemeData _outlinedButtonTheme({
    required Color border,
    required Color foreground,
    required Color pressed,
  }) =>
      OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
          foregroundColor: WidgetStatePropertyAll(foreground),
          overlayColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.pressed)
                ? pressed.withValues(alpha: 0.08)
                : null,
          ),
          side: WidgetStateProperty.resolveWith(
            (states) => BorderSide(
              color: states.contains(WidgetState.pressed) ? pressed : border,
              width: 1,
            ),
          ),
          padding: const WidgetStatePropertyAll(_buttonPadding),
          shape: WidgetStatePropertyAll(_buttonShape),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
      );
}
