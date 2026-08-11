import 'package:shared_preferences/shared_preferences.dart';

/// Small key-value settings (substitutes, optional private note, first-run
/// flag). Events live in Drift; these tiny prefs live in shared_preferences.
class SettingsService {
  static const _kSubs = 'pause_subs';
  static const _kNote = 'pause_note';
  static const _kSetup = 'pause_setup';
  static const _kInvitesEnabled = 'pause_invites_enabled';
  static const _kInviteOfferDismissed = 'pause_invite_offer_dismissed';
  static const _kLastInvitationFiredAt = 'pause_last_invitation_fired_at';

  static const _kInterceptionEnabled = 'pause_interception_enabled';
  static const _kInterceptedApps = 'pause_intercepted_apps';
  static const _kLastInterceptedAt = 'pause_last_intercepted_at';

  /// Every substitute the setup screen offers as a chip.
  static const presetSubstitutes = <String>[
    'Push-ups',
    'Walk',
    'Cold water',
    'Music',
    'Message a friend',
    'Step outside',
    'Stretch',
    'Read',
  ];

  /// The subset pre-selected on first run (and the fallback when nothing is
  /// saved yet), so the Off-ramp always has options.
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

  bool? get invitesEnabled => _prefs.getBool(_kInvitesEnabled);
  Future<void> setInvitesEnabled(bool value) =>
      _prefs.setBool(_kInvitesEnabled, value);

  bool get inviteOfferDismissed =>
      _prefs.getBool(_kInviteOfferDismissed) ?? false;
  Future<void> setInviteOfferDismissed(bool value) =>
      _prefs.setBool(_kInviteOfferDismissed, value);

  int? get lastInvitationFiredAt => _prefs.getInt(_kLastInvitationFiredAt);
  Future<void> setLastInvitationFiredAt(int value) =>
      _prefs.setInt(_kLastInvitationFiredAt, value);

  bool get interceptionEnabled =>
      _prefs.getBool(_kInterceptionEnabled) ?? false;
  Future<void> setInterceptionEnabled(bool value) =>
      _prefs.setBool(_kInterceptionEnabled, value);

  List<String> get interceptedApps =>
      _prefs.getStringList(_kInterceptedApps) ?? [];
  Future<void> setInterceptedApps(List<String> value) =>
      _prefs.setStringList(_kInterceptedApps, value);

  int? get lastInterceptedAt => _prefs.getInt(_kLastInterceptedAt);
  Future<void> setLastInterceptedAt(int value) =>
      _prefs.setInt(_kLastInterceptedAt, value);
}
