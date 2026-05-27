import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  static final RemoteConfigService instance = RemoteConfigService._init();
  RemoteConfigService._init();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  String _minRequiredVersion = "1.0.0";
  String _appStoreUrl = "";
  String _playStoreUrl = "";
  bool _isInitialized = false;

  String get minRequiredVersion => _minRequiredVersion;
  String get appStoreUrl => _appStoreUrl;
  String get playStoreUrl => _playStoreUrl;
  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: kDebugMode ? Duration.zero : const Duration(hours: 1),
      ));

      // Define local fallback defaults
      await _remoteConfig.setDefaults(<String, dynamic>{
        'min_required_version': '1.0.0',
        'app_store_url': 'https://apps.apple.com/app/idYOUR_APP_ID',
        'play_store_url': 'https://play.google.com/store/apps/details?id=com.impactdevelopment.remind_me_later',
      });

      await _remoteConfig.fetchAndActivate();

      _minRequiredVersion = _remoteConfig.getString('min_required_version');
      _appStoreUrl = _remoteConfig.getString('app_store_url');
      _playStoreUrl = _remoteConfig.getString('play_store_url');
      _isInitialized = true;
    } catch (e, stackTrace) {
      debugPrint("[RemoteConfig] ERROR during initialization: $e");
      debugPrint("[RemoteConfig] Stack trace: $stackTrace");
    }
  }

  Future<bool> isUpdateRequired() async {
    if (!_isInitialized) return false;

    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String currentVersion = packageInfo.version;
      return _isVersionLessThan(currentVersion, _minRequiredVersion);
    } catch (e) {
      debugPrint("[RemoteConfig] Error checking version compatibility: $e");
      return false;
    }
  }

  bool _isVersionLessThan(String current, String required) {
    final currentParts = current.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final requiredParts = required.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    final int maxLen = currentParts.length > requiredParts.length ? currentParts.length : requiredParts.length;
    for (int i = 0; i < maxLen; i++) {
      final currentVal = i < currentParts.length ? currentParts[i] : 0;
      final requiredVal = i < requiredParts.length ? requiredParts[i] : 0;

      if (currentVal < requiredVal) return true;
      if (currentVal > requiredVal) return false;
    }
    return false;
  }
}
