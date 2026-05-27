import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static final SettingsService instance = SettingsService._init();
  SharedPreferences? _prefs;

  SettingsService._init();

  Future<SharedPreferences> get prefs async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  static const String _keyComfortStart = 'comfort_start';
  static const String _keyComfortEnd = 'comfort_end';
  static const String _keyHasOnboarded = 'has_onboarded';
  static const String _keyTermsAccepted = 'terms_accepted';
  static const String _keyBgAnimEnabled = 'bg_anim_enabled';

  Future<int> getComfortStart() async {
    final p = await prefs;
    return p.getInt(_keyComfortStart) ?? 9;
  }

  Future<int> getComfortEnd() async {
    final p = await prefs;
    return p.getInt(_keyComfortEnd) ?? 21;
  }

  Future<bool> getHasOnboarded() async {
    final p = await prefs;
    return p.getBool(_keyHasOnboarded) ?? false;
  }

  Future<bool> getTermsAccepted() async {
    final p = await prefs;
    return p.getBool(_keyTermsAccepted) ?? false;
  }

  Future<bool> getBackgroundAnimationsEnabled() async {
    final p = await prefs;
    return p.getBool(_keyBgAnimEnabled) ?? true;
  }

  Future<void> saveComfortHours(int start, int end) async {
    final p = await prefs;
    await p.setInt(_keyComfortStart, start);
    await p.setInt(_keyComfortEnd, end);
    await p.setBool(_keyHasOnboarded, true);
  }

  Future<void> setTermsAccepted(bool accepted) async {
    final p = await prefs;
    await p.setBool(_keyTermsAccepted, accepted);
  }

  Future<void> setBackgroundAnimationsEnabled(bool enabled) async {
    final p = await prefs;
    await p.setBool(_keyBgAnimEnabled, enabled);
  }
}
