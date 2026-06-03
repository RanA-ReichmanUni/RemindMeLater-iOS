import 'package:flutter/material.dart';
import 'package:remind_me_later/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/reminder_provider.dart';

class MenuScreen extends StatelessWidget {
  final VoidCallback onClose;

  const MenuScreen({super.key, required this.onClose});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $urlString');
    }
  }

  void _openAccessibilityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        final colors = Theme.of(context).colorScheme;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(l10n.accessibilityTitle),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              child: Text(
                l10n.accessibilityExemptionText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(l10n.accessibilityClose),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final provider = Provider.of<ReminderProvider>(context);

    final isAndroid = theme.platform == TargetPlatform.android;
    final String termsLink = isAndroid
        ? 'https://doc-hosting.flycricket.io/remind-me-later-dump-forget-terms/066e5c03-811f-465e-9d68-99caef56d362/terms'
        : 'https://doc-hosting.flycricket.io/remind-me-later-dump-forget-terms-and-conditions-agreement-ios-ipados-macos/b4e271d7-8ab2-4c34-9e7c-b29cef54cb9e/terms';
    const String privacyLink =
        'https://doc-hosting.flycricket.io/remind-me-later-dump-forget/26727942-d484-494a-a3b7-212119dfbe13/privacy';

    final legalColor = colors.onSurfaceVariant; // Contrast fix (removed opacity)

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colors.background,
              colors.surfaceVariant.withOpacity(0.5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                color: colors.surface,
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context).menuLabel,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context).menuOptions,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: onClose,
                            tooltip: "Close menu",
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Animation Control Card
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(
                            color: colors.outline.withOpacity(0.2),
                            width: 1.0,
                          ),
                        ),
                        color: colors.surface,
                        elevation: 0,
                        borderOnForeground: true,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                AppLocalizations.of(context).backgroundAnimation,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppLocalizations.of(context).backgroundAnimationSubtitle,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  // ON Button
                                  Expanded(
                                    child: Semantics(
                                      button: true,
                                      selected: provider.backgroundAnimationsEnabled,
                                      hint: "Double tap to enable background animations",
                                      child: provider.backgroundAnimationsEnabled
                                          ? ElevatedButton.icon(
                                              onPressed: () => provider.setBackgroundAnimationsEnabled(true),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: colors.primaryContainer,
                                                foregroundColor: colors.onPrimaryContainer,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                elevation: 0,
                                              ),
                                              icon: const Icon(Icons.motion_photos_on, size: 18),
                                              label: Text(AppLocalizations.of(context).onLabel),
                                            )
                                          : OutlinedButton.icon(
                                              onPressed: () => provider.setBackgroundAnimationsEnabled(true),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: colors.onSurface,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              icon: const Icon(Icons.motion_photos_on, size: 18),
                                              label: Text(AppLocalizations.of(context).onLabel),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // OFF Button
                                  Expanded(
                                    child: Semantics(
                                      button: true,
                                      selected: !provider.backgroundAnimationsEnabled,
                                      hint: "Double tap to disable background animations",
                                      child: !provider.backgroundAnimationsEnabled
                                          ? ElevatedButton.icon(
                                              onPressed: () => provider.setBackgroundAnimationsEnabled(false),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: colors.primaryContainer,
                                                foregroundColor: colors.onPrimaryContainer,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                elevation: 0,
                                              ),
                                              icon: const Icon(Icons.motion_photos_off, size: 18),
                                              label: Text(AppLocalizations.of(context).offLabel),
                                            )
                                          : OutlinedButton.icon(
                                              onPressed: () => provider.setBackgroundAnimationsEnabled(false),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: colors.onSurface,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              icon: const Icon(Icons.motion_photos_off, size: 18),
                                              label: Text(AppLocalizations.of(context).offLabel),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Legal Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).legalLabel,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: legalColor,
                              fontSize: 10,
                            ),
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () => _launchUrl(privacyLink),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  AppLocalizations.of(context).privacyPolicy,
                                  style: theme.textTheme.labelMedium?.copyWith(color: legalColor),
                                ),
                              ),
                              Text('/', style: theme.textTheme.labelMedium?.copyWith(color: legalColor)),
                              TextButton(
                                onPressed: () => _launchUrl(termsLink),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  AppLocalizations.of(context).termsLabel,
                                  style: theme.textTheme.labelMedium?.copyWith(color: legalColor),
                                ),
                              ),
                              Text('/', style: theme.textTheme.labelMedium?.copyWith(color: legalColor)),
                              TextButton(
                                onPressed: () => _openAccessibilityDialog(context),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  AppLocalizations.of(context).accessibilityButton,
                                  style: theme.textTheme.labelMedium?.copyWith(color: legalColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
