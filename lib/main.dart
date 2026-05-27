import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
import 'ui/screens/menu_screen.dart';
import 'ui/screens/update_wall_screen.dart';
import 'ui/components/comfort_hours_sheet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await NotificationService.instance.init();

  bool needsUpdate = false;
  try {
    debugPrint("[Main] Initializing Firebase...");
    await Firebase.initializeApp();
    debugPrint("[Main] Firebase initialized. Initializing Remote Config...");
    await RemoteConfigService.instance.init();
    debugPrint("[Main] Remote Config initialized. Checking if update is required...");
    needsUpdate = await RemoteConfigService.instance.isUpdateRequired();
    debugPrint("[Main] needsUpdate = $needsUpdate");
  } catch (e, stackTrace) {
    debugPrint("[Main] Firebase/RemoteConfig initialization skipped or failed: $e");
    debugPrint("[Main] Stack trace: $stackTrace");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
      ],
      child: RemindMeLaterApp(needsUpdate: needsUpdate),
    ),
  );
}

class RemindMeLaterApp extends StatelessWidget {
  final bool needsUpdate;
  const RemindMeLaterApp({super.key, required this.needsUpdate});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReminderProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          title: 'Remind Me Later',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: MainOrchestrator(needsUpdate: needsUpdate),
        );
      },
    );
  }
}

class MainOrchestrator extends StatefulWidget {
  final bool needsUpdate;
  const MainOrchestrator({super.key, required this.needsUpdate});

  @override
  State<MainOrchestrator> createState() => _MainOrchestratorState();
}

enum AppTab { dump, reminders }

class _MainOrchestratorState extends State<MainOrchestrator> {
  AppTab _selectedTab = AppTab.dump;
  String? _prefillText;
  bool _showMenu = false;
  Reminder? _activeForegroundAlarm;

  @override
  void initState() {
    super.initState();
    // Listen to foreground alarm trigger events
    NotificationService.instance.alarmStream.listen((Reminder reminder) {
      setState(() {
        _activeForegroundAlarm = reminder;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReminderProvider>(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // ── 0. If update is required, show Update Wall Screen ──
    if (widget.needsUpdate) {
      return const UpdateWallScreen();
    }

    // ── 1. If foreground alarm active, show Alarm Screen ──
    if (_activeForegroundAlarm != null) {
      return AlarmScreen(
        reminder: _activeForegroundAlarm!,
        onDismiss: () {
          setState(() {
            _activeForegroundAlarm = null;
          });
        },
      );
    }

    // ── 2. Agree to Terms and Conditions first ──
    if (!provider.termsAccepted) {
      return TermsScreen(
        onAgree: () {
          provider.acceptTerms();
        },
        onCancel: () {
          exit(0);
        },
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
                label: 'Dump',
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
                label: 'Reminders',
                icon: Icons.notifications_none,
                selectedIcon: Icons.notifications,
                isSelected: selectedTab == AppTab.reminders,
                onClick: () => onTabSelected(AppTab.reminders),
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
    return GestureDetector(
      onTap: onClick,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        height: 54,
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
              size: isSelected ? 22 : 20,
              color: isSelected ? colors.primary : colors.onSurfaceVariant,
            ),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? colors.primary : colors.onSurfaceVariant,
              ),
            ),
            if (isSelected)
              Text(
                '•',
                style: TextStyle(
                  color: colors.primary,
                  height: 0.6,
                  fontSize: 10,
                ),
              ),
          ],
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
    return GestureDetector(
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
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu,
              color: colors.onSurface,
              size: 20,
            ),
            const SizedBox(width: 6),
            Text(
              'Menu',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
