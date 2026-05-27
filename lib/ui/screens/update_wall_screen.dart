import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/remote_config_service.dart';
import '../components/animated_backdrop.dart';

class UpdateWallScreen extends StatelessWidget {
  const UpdateWallScreen({super.key});

  Future<void> _handleUpdate() async {
    final remoteConfig = RemoteConfigService.instance;
    final String urlString = Platform.isIOS ? remoteConfig.appStoreUrl : remoteConfig.playStoreUrl;

    if (urlString.isEmpty) return;

    final Uri url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Could not launch update URL: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          // Background Animation
          const AnimatedBackdrop(animate: true),

          // Central Card content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                    side: BorderSide(
                      color: colors.primary.withOpacity(0.20),
                      width: 1.0,
                    ),
                  ),
                  color: colors.surface.withOpacity(0.92),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Update Icon / Emoji
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: colors.primary.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.system_update_alt_rounded,
                            size: 40,
                            color: colors.primary,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Title
                        Text(
                          'Update Required',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: colors.primary,
                            fontSize: 26,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Message
                        Text(
                          'A new version of Remind Me Later is available. Please update to the latest version to continue using the app.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Update Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _handleUpdate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 4,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.download_rounded, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Update Now',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
