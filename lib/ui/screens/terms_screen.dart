import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsScreen extends StatelessWidget {
  final VoidCallback onAgree;
  final VoidCallback? onCancel;
  final bool isReagreement;

  const TermsScreen({
    super.key,
    required this.onAgree,
    this.onCancel,
    this.isReagreement = false,
  });

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    const String termsLink =
        'https://doc-hosting.flycricket.io/remind-me-later-dump-forget-terms-and-conditions-agreement-ios-ipados-macos/b4e271d7-8ab2-4c34-9e7c-b29cef54cb9e/terms';
    const String privacyLink =
        'https://doc-hosting.flycricket.io/remind-me-later-dump-forget/26727942-d484-494a-a3b7-212119dfbe13/privacy';

    final textLinkStyle = TextStyle(
      color: colors.primary,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline,
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colors.background,
              colors.surfaceVariant.withOpacity(0.45),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              shape: RoundedCornerShape(24),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      isReagreement
                          ? 'Policies Updated'
                          : 'Agree to continue',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (isReagreement) ...[
                      const SizedBox(height: 6),
                      Text(
                        'The app has been updated. Please review and accept the terms again to continue.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    RichText(
                      text: TextSpan(
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.onSurface,
                        ),
                        children: [
                          const TextSpan(text: 'By using this app, you agree to the '),
                          TextSpan(
                            text: 'Terms and Conditions',
                            style: textLinkStyle,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => _launchUrl(termsLink),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: textLinkStyle,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => _launchUrl(privacyLink),
                          ),
                          const TextSpan(text: '.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'In addition to the policies agreement, please note that apps can make mistakes and alerts may not always fire. Do not rely on this app for important, critical or time-sensitive reminders.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        if (onCancel != null) ...[
                          Expanded(
                            child: OutlinedButton(
                              onPressed: onCancel,
                              style: OutlinedButton.styleFrom(
                                shape: RoundedCornerShape(16),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                        Expanded(
                          child: ElevatedButton(
                            onPressed: onAgree,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                              shape: RoundedCornerShape(16),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('I Read and Agreed'),
                          ),
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
    );
  }
}

// Helper rounding function to matches Android shapes
class RoundedCornerShape extends RoundedRectangleBorder {
  RoundedCornerShape(double radius)
      : super(borderRadius: BorderRadius.circular(radius));
}
