import 'package:shared_preferences/shared_preferences.dart';

/// Small key-value settings (substitutes, optional private note, first-run
/// flag). Events live in Drift; these tiny prefs live in shared_preferences.
class SettingsService {
  static const _kSubs = 'pause_subs';
  static const _kNote = 'pause_note';
  static const _kSetup = 'pause_setup';

  static const defaultSubstitutes = <String>[
    'Push-ups',
    'Walk',
    'Cold water',
    'Music',
    'Message a friend',
  ];

  late SharedPreferences _prefs;

  /// Must be awaited once before any getter is read (called at startup).
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get setupComplete => _prefs.getBool(_kSetup) ?? false;

  List<String> get substitutes =>
      _prefs.getStringList(_kSubs) ?? defaultSubstitutes;

  String get habitNote => _prefs.getString(_kNote) ?? '';

  Future<void> completeSetup({
    required List<String> substitutes,
    String? note,
  }) async {
    await _prefs.setStringList(_kSubs, substitutes);
    if (note != null) await _prefs.setString(_kNote, note);
    await _prefs.setBool(_kSetup, true);
  }

  Future<void> resetSetup() => _prefs.remove(_kSetup);
}
