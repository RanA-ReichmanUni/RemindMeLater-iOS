import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:remind_me_later/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'models/reminder.dart';
import 'models/timeframe.dart';
import 'providers/reminder_provider.dart';
import 'services/notification_service.dart';
import 'services/remote_config_service.dart';
import 'ui/theme/app_theme.dart';
import 'ui/screens/terms_screen.dart';
import 'ui/screens/dump_screen.dart';
import 'ui/screens/reminders_screen.dart';
import 'ui/screens/alarm_screen.dart';
import 'ui/screens/missed_screen.dart';
import 'ui/screens/menu_screen.dart';
import 'ui/screens/update_wall_screen.dart';
import 'ui/components/comfort_hours_sheet.dart';
import 'package:in_app_update/in_app_update.dart';
import 'config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool needsUpdate = false;
  try {
    await Firebase.initializeApp();
    await RemoteConfigService.instance.init();
    needsUpdate = await RemoteConfigService.instance.isUpdateRequired();
  } catch (e, stackTrace) {
    debugPrint("[Main] Firebase/RemoteConfig initialization failed: $e");
    debugPrint("[Main] Stack trace: $stackTrace");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
      ],
      child: RemindMeLaterApp(initialNeedsUpdate: needsUpdate),
    ),
  );

  // Initialize notification service AFTER the UI is running to avoid
  // deadlocks on older Android versions (e.g. Android 10) where
  // requesting permissions before the engine is active can hang the app.
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await NotificationService.instance.init();
  });
}

class RemindMeLaterApp extends StatelessWidget {
  final bool initialNeedsUpdate;
  const RemindMeLaterApp({super.key, required this.initialNeedsUpdate});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReminderProvider>(
      builder: (context, provider, child) {
        // Don't render the app until the provider has loaded from disk.
        // This prevents a white frame on slow/older devices.
        if (provider.isLoading) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: SizedBox.shrink(),
            ),
          );
        }
        return MaterialApp(
          title: 'Remind Me Later',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: kEnableTranslations ? const [
            Locale('en'),
            Locale('es'),
            Locale('fr'),
            Locale('de'),
            Locale('ja'),
            Locale('zh'),
            Locale('he'),
          ] : const [
            Locale('en'),
          ],
          home: MainOrchestrator(initialNeedsUpdate: initialNeedsUpdate),
        );
      },
    );
  }
}

class MainOrchestrator extends StatefulWidget {
  final bool initialNeedsUpdate;
  const MainOrchestrator({super.key, required this.initialNeedsUpdate});

  @override
  State<MainOrchestrator> createState() => _MainOrchestratorState();
}

enum AppTab { dump, reminders, missed }

class _MainOrchestratorState extends State<MainOrchestrator>
    with WidgetsBindingObserver {
  AppTab _selectedTab = AppTab.dump;
  String? _prefillText;
  bool _showMenu = false;
  Reminder? _activeForegroundAlarm;
  bool _playSiren = false;
  late bool _needsUpdate;

  @override
  void initState() {
    super.initState();
    _needsUpdate = widget.initialNeedsUpdate;
    WidgetsBinding.instance.addObserver(this);
    _checkForAndroidUpdates();

    // Listen to explicit notification taps
    NotificationService.instance.alarmStream.listen((Reminder reminder) {
      if (mounted) {
        setState(() {
          _playSiren = false; // It already played the notification sound
          _activeForegroundAlarm = reminder;
        });
      }
    });

    // Listen to background actions (Done/Snooze) to reload UI
    NotificationService.instance.actionStream.listen((_) {
      if (mounted) {
        Provider.of<ReminderProvider>(context, listen: false).refreshReminders();
      }
    });

    // Handle alarms triggered when app was completely closed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.instance.consumePendingLaunchAlarm();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _refreshUpdateStatus();
      if (mounted) {
        Provider.of<ReminderProvider>(context, listen: false).refreshReminders();
      }
    }
  }

  /// Re-fetch Remote Config from the server and update the update-wall
  /// state.  This runs every time the user brings the app back to the
  /// foreground, so a newly published Remote Config value takes effect
  /// without reinstalling.
  Future<void> _refreshUpdateStatus() async {
    try {
      final bool required =
          await RemoteConfigService.instance.forceRefresh();
      if (mounted && required != _needsUpdate) {
        setState(() {
          _needsUpdate = required;
        });
      }
    } catch (e) {
      debugPrint("[Main] _refreshUpdateStatus failed: $e");
    }
  }

  Future<void> _checkForAndroidUpdates() async {
    if (Platform.isAndroid) {
      try {
        final updateInfo = await InAppUpdate.checkForUpdate();
        if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
          await InAppUpdate.performImmediateUpdate();
        }
      } catch (e) {
        debugPrint("[Main] InAppUpdate error: $e");
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReminderProvider>(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // ── 0. If update is required, show Update Wall Screen ──
    if (_needsUpdate) {
      return const UpdateWallScreen();
    }

    // ── 1. If user explicitly tapped a notification, show Alarm Screen ──
    if (_activeForegroundAlarm != null) {
      return AlarmScreen(
        reminder: _activeForegroundAlarm!,
        playSiren: _playSiren,
        onDismiss: () {
          setState(() {
            _activeForegroundAlarm = null;
          });
          // Also refresh the missed tab just in case they ignored it
          provider.refreshReminders();
        },
      );
    }

    // ── 2. Agree to Terms and Conditions first (also re-shown on new versions) ──
    if (provider.termsNeedReagreement) {
      final isReagreement = provider.termsAccepted; // already agreed once before
      return TermsScreen(
        isReagreement: isReagreement,
        onAgree: () {
          provider.acceptTerms();
        },
        onCancel: isReagreement ? null : () => exit(0),
      );
    }

    // ── 3. Onboarding Comfort Hours flow ──
    if (!provider.hasOnboarded) {
      return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Card(
              margin: const EdgeInsets.all(24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              child: ComfortHoursSheet(
                initialStart: provider.comfortStart,
                initialEnd: provider.comfortEnd,
                onDismiss: () {}, // intentionally no-op: user must save before proceeding
                onSave: (start, end) {
                  provider.saveComfortHours(start, end);
                },
              ),
            ),
          ),
        ),
      );
    }

    // ── 4. Main Tab Navigation ──
    return Scaffold(
      bottomNavigationBar: _PremiumBottomBar(
        selectedTab: _selectedTab,
        onTabSelected: (tab) {
          setState(() {
            _selectedTab = tab;
          });
        },
      ),
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedTab.index,
            children: [
              DumpScreen(
                prefillText: _prefillText,
                onPrefillConsumed: () {
                  setState(() {
                    _prefillText = null;
                  });
                },
              ),
              const RemindersScreen(),
              const MissedScreen(),
            ],
          ),

          // Menu button floating in the top right
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 12,
            child: _MenuPillButton(
              onClick: () {
                setState(() {
                  _showMenu = true;
                });
              },
              theme: theme,
              colors: colors,
            ),
          ),

          // Menu Screen overlay
          if (_showMenu)
            Positioned.fill(
              child: MenuScreen(
                onClose: () {
                  setState(() {
                    _showMenu = false;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _PremiumBottomBar extends StatelessWidget {
  final AppTab selectedTab;
  final ValueChanged<AppTab> onTabSelected;

  const _PremiumBottomBar({
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final provider = Provider.of<ReminderProvider>(context);
    final missedCount = provider.firedCount;
    final warmAccent = Color.lerp(colors.error, Colors.orange, 0.45)!;

    return Container(
      margin: const EdgeInsets.only(left: 14, right: 14, bottom: 18, top: 10),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: _PremiumNavItem(
                label: AppLocalizations.of(context).tabDump,
                icon: Icons.create_outlined,
                selectedIcon: Icons.create,
                isSelected: selectedTab == AppTab.dump,
                onClick: () => onTabSelected(AppTab.dump),
                colors: colors,
                theme: theme,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _PremiumNavItem(
                label: AppLocalizations.of(context).tabReminders,
                icon: Icons.notifications_none,
                selectedIcon: Icons.notifications,
                isSelected: selectedTab == AppTab.reminders,
                onClick: () => onTabSelected(AppTab.reminders),
                colors: colors,
                theme: theme,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _BadgedNavItem(
                label: 'Missed',
                icon: Icons.inbox_outlined,
                selectedIcon: Icons.inbox,
                isSelected: selectedTab == AppTab.missed,
                badgeCount: missedCount,
                badgeColor: warmAccent,
                onClick: () => onTabSelected(AppTab.missed),
                colors: colors,
                theme: theme,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumNavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;
  final VoidCallback onClick;
  final ColorScheme colors;
  final ThemeData theme;

  const _PremiumNavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    required this.onClick,
    required this.colors,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final double textScale = MediaQuery.textScalerOf(context).scale(1.0);
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      hint: isSelected ? "Currently active tab" : "Double tap to switch to $label tab",
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onClick,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          height: 54 * textScale.clamp(1.0, 1.8),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.primaryContainer.withOpacity(0.45)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                size: (isSelected ? 22 : 20) * textScale.clamp(1.0, 1.4),
                color: isSelected ? colors.primary : colors.onSurfaceVariant,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? colors.primary : colors.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (isSelected)
                Text(
                  '•',
                  style: TextStyle(
                    color: colors.primary,
                    height: 0.6,
                    fontSize: 10 * textScale.clamp(1.0, 1.4),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgedNavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;
  final int badgeCount;
  final Color badgeColor;
  final VoidCallback onClick;
  final ColorScheme colors;
  final ThemeData theme;

  const _BadgedNavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    required this.badgeCount,
    required this.badgeColor,
    required this.onClick,
    required this.colors,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final double textScale = MediaQuery.textScalerOf(context).scale(1.0);
    return Semantics(
      button: true,
      selected: isSelected,
      label: '$label, $badgeCount items',
      hint: isSelected ? "Currently active tab" : "Double tap to switch to $label tab",
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onClick,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          height: 54 * textScale.clamp(1.0, 1.8),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.primaryContainer.withOpacity(0.45)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    isSelected ? selectedIcon : icon,
                    size: (isSelected ? 22 : 20) * textScale.clamp(1.0, 1.4),
                    color: isSelected ? colors.primary : colors.onSurfaceVariant,
                  ),
                  if (badgeCount > 0)
                    Positioned(
                      right: -8,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Center(
                          child: Text(
                            '$badgeCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? colors.primary : colors.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (isSelected)
                Text(
                  '•',
                  style: TextStyle(
                    color: colors.primary,
                    height: 0.6,
                    fontSize: 10 * textScale.clamp(1.0, 1.4),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuPillButton extends StatelessWidget {
  final VoidCallback onClick;
  final ThemeData theme;
  final ColorScheme colors;

  const _MenuPillButton({
    required this.onClick,
    required this.theme,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final double textScale = MediaQuery.textScalerOf(context).scale(1.0);
    return Semantics(
      button: true,
      label: AppLocalizations.of(context).menuLabel,
      hint: "Opens settings and accessibility menu",
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface.withOpacity(0.96),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: colors.outlineVariant.withOpacity(0.6),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 12.0 * textScale.clamp(1.0, 1.5),
            vertical: 8.0 * textScale.clamp(1.0, 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.menu,
                color: colors.onSurface,
                size: 20 * textScale.clamp(1.0, 1.4),
              ),
              const SizedBox(width: 6),
              Text(
                AppLocalizations.of(context).menuLabel,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

