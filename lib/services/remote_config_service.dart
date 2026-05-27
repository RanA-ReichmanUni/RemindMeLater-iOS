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
      debugPrint("[RemoteConfig] Setting config settings...");
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

      debugPrint("[RemoteConfig] Fetching and activating...");
      final bool activated = await _remoteConfig.fetchAndActivate();
      debugPrint("[RemoteConfig] fetchAndActivate completed. Activated new values: $activated");

      _minRequiredVersion = _remoteConfig.getString('min_required_version');
      _appStoreUrl = _remoteConfig.getString('app_store_url');
      _playStoreUrl = _remoteConfig.getString('play_store_url');
      _isInitialized = true;
      debugPrint("[RemoteConfig] Initialized. min_required_version = '$_minRequiredVersion'");
    } catch (e, stackTrace) {
      debugPrint("[RemoteConfig] ERROR during initialization: $e");
      debugPrint("[RemoteConfig] Stack trace: $stackTrace");
    }
  }

  Future<bool> isUpdateRequired() async {
    debugPrint("[RemoteConfig] isUpdateRequired called. isInitialized=$_isInitialized");
    if (!_isInitialized) {
      debugPrint("[RemoteConfig] Not initialized — skipping check, returning false.");
      return false;
    }

    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String currentVersion = packageInfo.version;
      debugPrint("[RemoteConfig] Current app version: '$currentVersion', min required: '$_minRequiredVersion'");

      final bool result = _isVersionLessThan(currentVersion, _minRequiredVersion);
      debugPrint("[RemoteConfig] isUpdateRequired result: $result");
      return result;
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
