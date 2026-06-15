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
        // In debug mode, fetch every time. In production, fetch at most
        // once every 30 minutes to avoid client-side throttling.
        // The SDK will automatically return cached data if we call fetch()
        // before the 30 minutes are up.
        minimumFetchInterval: kDebugMode ? Duration.zero : const Duration(minutes: 30),
      ));

      // Define local fallback defaults
      await _remoteConfig.setDefaults(<String, dynamic>{
        'min_required_version': '1.0.0',
        'app_store_url': 'https://apps.apple.com/us/app/id6774295301',
        'play_store_url': 'https://play.google.com/store/apps/details?id=com.impactdevelopment.remind_me_later',
      });

      // ensureInitialized loads the last successfully fetched values from
      // disk so they are available immediately, even before fetchAndActivate.
      await _remoteConfig.ensureInitialized();

      // Fetch fresh values from the server on every init.
      await _fetchAndApply();

      debugPrint("[RemoteConfig] min_required_version = $_minRequiredVersion");
      final PackageInfo info = await PackageInfo.fromPlatform();
      debugPrint("[RemoteConfig] current app version = ${info.version} (build: ${info.buildNumber})");
      debugPrint("[RemoteConfig] update required = ${_isVersionLessThan(info.version, _minRequiredVersion)}");
    } catch (e, stackTrace) {
      debugPrint("[RemoteConfig] ERROR during initialization: $e");
      debugPrint("[RemoteConfig] Stack trace: $stackTrace");
    }
  }

  /// Re-fetch remote config from the server and re-evaluate the update
  /// requirement.  Called on every app resume so the update wall can
  /// appear (or disappear) without reinstalling.
  Future<bool> forceRefresh() async {
    try {
      await _fetchAndApply();
      return await isUpdateRequired();
    } catch (e) {
      debugPrint("[RemoteConfig] forceRefresh failed: $e");
      return _isInitialized ? await isUpdateRequired() : false;
    }
  }

  /// Shared helper: fetch from server, activate, and store the values.
  Future<void> _fetchAndApply() async {
    try {
      final bool updated = await _remoteConfig.fetchAndActivate();
      debugPrint("[RemoteConfig] fetchAndActivate result (true=new data): $updated");
    } catch (fetchError) {
      debugPrint("[RemoteConfig] Fetch failed: $fetchError");
    }

    _minRequiredVersion = _remoteConfig.getString('min_required_version');
    _appStoreUrl = _remoteConfig.getString('app_store_url');
    _playStoreUrl = _remoteConfig.getString('play_store_url');
    _isInitialized = true;
  }

  Future<bool> isUpdateRequired() async {
    debugPrint("[RemoteConfig] isUpdateRequired called. _isInitialized: $_isInitialized");
    if (!_isInitialized) return false;

    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String currentVersion = packageInfo.version;
      debugPrint("[RemoteConfig] Comparing current: $currentVersion with required: $_minRequiredVersion");
      final bool requiresUpdate = _isVersionLessThan(currentVersion, _minRequiredVersion);
      debugPrint("[RemoteConfig] isUpdateRequired returning: $requiresUpdate");
      return requiresUpdate;
    } catch (e) {
      debugPrint("[RemoteConfig] Error checking version compatibility: $e");
      return false;
    }
  }

  bool _isVersionLessThan(String current, String required) {
    final currentParts = current.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final requiredParts = required.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    debugPrint("[RemoteConfig] currentParts: $currentParts");
    debugPrint("[RemoteConfig] requiredParts: $requiredParts");

    final int maxLen = currentParts.length > requiredParts.length ? currentParts.length : requiredParts.length;
    for (int i = 0; i < maxLen; i++) {
      final currentVal = i < currentParts.length ? currentParts[i] : 0;
      final requiredVal = i < requiredParts.length ? requiredParts[i] : 0;

      debugPrint("[RemoteConfig] comparing part $i: currentVal=$currentVal, requiredVal=$requiredVal");

      if (currentVal < requiredVal) return true;
      if (currentVal > requiredVal) return false;
    }
    return false;
  }
}
