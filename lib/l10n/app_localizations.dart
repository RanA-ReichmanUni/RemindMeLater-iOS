import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('he'),
    Locale('ja'),
    Locale('zh')
  ];

  /// Tagline under the app brand on the dump screen
  ///
  /// In en, this message translates to:
  /// **'We\'ll ping you later, when it\'s more convenient.'**
  String get tagline;

  /// Header above the text input on the dump screen
  ///
  /// In en, this message translates to:
  /// **'Dump your chaos here'**
  String get dumpInputHeader;

  /// Placeholder inside the text field
  ///
  /// In en, this message translates to:
  /// **'What\'s on your mind?'**
  String get dumpHintText;

  /// Label for the timeframe selector card on the dump screen
  ///
  /// In en, this message translates to:
  /// **'Timing vibe'**
  String get timingVibeLabel;

  /// Primary action button on the dump screen
  ///
  /// In en, this message translates to:
  /// **'Remind Me Later'**
  String get remindMeLaterBtn;

  /// Button to clear the text field
  ///
  /// In en, this message translates to:
  /// **'Clear draft'**
  String get clearDraft;

  /// Success overlay title after saving a reminder
  ///
  /// In en, this message translates to:
  /// **'Got it!'**
  String get gotIt;

  /// Success overlay subtitle after saving a reminder
  ///
  /// In en, this message translates to:
  /// **'We\'ll remind you later 🤙'**
  String get wellRemindYouLater;

  /// Bottom nav tab label for the dump screen
  ///
  /// In en, this message translates to:
  /// **'Dump'**
  String get tabDump;

  /// Bottom nav tab label for the reminders screen
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get tabReminders;

  /// Menu button pill label and menu screen title
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menuLabel;

  /// Subtitle under the Menu heading
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get menuOptions;

  /// Setting title for the animated backdrop toggle
  ///
  /// In en, this message translates to:
  /// **'Background animation'**
  String get backgroundAnimation;

  /// Setting description for the animated backdrop toggle
  ///
  /// In en, this message translates to:
  /// **'Subtle motion behind the dump screen'**
  String get backgroundAnimationSubtitle;

  /// Toggle option: On
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get onLabel;

  /// Toggle option: Off
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get offLabel;

  /// Section heading for legal links in the menu
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legalLabel;

  /// Link text for the Privacy Policy
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Link text for the Terms and Conditions
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get termsLabel;

  /// Small caps label at the top of the reminders screen header
  ///
  /// In en, this message translates to:
  /// **'DUMP & FORGET'**
  String get dumpForgetHeader;

  /// Reminders screen section title
  ///
  /// In en, this message translates to:
  /// **'Chaos queue'**
  String get chaosQueue;

  /// Reminders count label when count is exactly 1
  ///
  /// In en, this message translates to:
  /// **'I\'m tracking 1 thing for you'**
  String get trackingOne;

  /// Reminders count label when count is not 1
  ///
  /// In en, this message translates to:
  /// **'I\'m tracking {count} things for you'**
  String trackingCount(int count);

  /// Comfort hours label shown as a pill on the reminders screen
  ///
  /// In en, this message translates to:
  /// **'Comfort {start} - {end}'**
  String comfortWindowLabel(String start, String end);

  /// Button to load more reminders in the list
  ///
  /// In en, this message translates to:
  /// **'Load more ({remaining} remaining)'**
  String loadMore(int remaining);

  /// Dialog title when confirming a reminder is done
  ///
  /// In en, this message translates to:
  /// **'Mark as handled?'**
  String get markAsHandled;

  /// Dialog body when confirming a reminder is done
  ///
  /// In en, this message translates to:
  /// **'This reminder will be removed from your active queue.'**
  String get markHandledBody;

  /// Generic cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Confirm button in the mark-as-handled dialog
  ///
  /// In en, this message translates to:
  /// **'Yes, handled'**
  String get yesHandled;

  /// Primary action button on a reminder card
  ///
  /// In en, this message translates to:
  /// **'Handled'**
  String get handled;

  /// Secondary action button on a reminder card to expand delay options
  ///
  /// In en, this message translates to:
  /// **'Delay'**
  String get delay;

  /// Button to collapse the delay options on a reminder card
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Label above the delay options grid on a reminder card
  ///
  /// In en, this message translates to:
  /// **'Cool, kick it to:'**
  String get coolKickTo;

  /// Empty state title on the reminders screen
  ///
  /// In en, this message translates to:
  /// **'Zero chaos in the queue'**
  String get zeroChaosin;

  /// Empty state subtitle on the reminders screen
  ///
  /// In en, this message translates to:
  /// **'Brain-dump on the other tab. I\'ll take it from there.'**
  String get brainDumpOther;

  /// Subtitle on the alarm screen
  ///
  /// In en, this message translates to:
  /// **'You wanted to be reminded about this.'**
  String get youWantedReminded;

  /// Done button on the alarm screen
  ///
  /// In en, this message translates to:
  /// **'✓  Done'**
  String get doneBtn;

  /// Snooze button on the alarm screen (collapsed state)
  ///
  /// In en, this message translates to:
  /// **'💤  Snooze'**
  String get snoozeBtn;

  /// Cancel button on the alarm screen (snooze panel open)
  ///
  /// In en, this message translates to:
  /// **'✕  Cancel'**
  String get cancelSnooze;

  /// Header of the snooze options panel
  ///
  /// In en, this message translates to:
  /// **'Snooze until…'**
  String get snoozeUntil;

  /// Snooze option: later today
  ///
  /// In en, this message translates to:
  /// **'⚡ Later today'**
  String get snoozeLaterToday;

  /// Snooze option: tomorrow
  ///
  /// In en, this message translates to:
  /// **'🌅 Tomorrow'**
  String get snoozeTomorrow;

  /// Snooze option: next few days
  ///
  /// In en, this message translates to:
  /// **'🌤 Next few days'**
  String get snoozeNextFewDays;

  /// Snooze option: next weeks
  ///
  /// In en, this message translates to:
  /// **'🌙 Next weeks'**
  String get snoozeNextWeeks;

  /// Snooze option: next month
  ///
  /// In en, this message translates to:
  /// **'🌊 Next month'**
  String get snoozeNextMonth;

  /// Title of the comfort hours bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Comfort hours'**
  String get comfortHoursTitle;

  /// Subtitle of the comfort hours bottom sheet
  ///
  /// In en, this message translates to:
  /// **'We\'ll only send reminders during these hours — so you\'re never bothered outside your day.'**
  String get comfortHoursSubtitle;

  /// Label for the start-hour stepper
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get fromLabel;

  /// Label for the end-hour stepper
  ///
  /// In en, this message translates to:
  /// **'Until'**
  String get untilLabel;

  /// Warning shown when comfort hours span across midnight
  ///
  /// In en, this message translates to:
  /// **'Spans overnight — comfort window crosses midnight (night shift).'**
  String get spansOvernight;

  /// Save button in the comfort hours sheet
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveBtn;

  /// Title of the timeframe picker bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Timing vibe'**
  String get timingVibeTitle;

  /// Subtitle of the timeframe picker bottom sheet
  ///
  /// In en, this message translates to:
  /// **'When should future-you deal with this?'**
  String get timingVibeSubtitle;

  /// Title of the comfort-hours warning dialog
  ///
  /// In en, this message translates to:
  /// **'Outside your comfort hours'**
  String get outsideComfortHours;

  /// Action button in the comfort-hours warning dialog
  ///
  /// In en, this message translates to:
  /// **'Schedule for tomorrow'**
  String get scheduleForTomorrow;

  /// Action button in the comfort-hours warning dialog
  ///
  /// In en, this message translates to:
  /// **'Alert me anyway'**
  String get alertMeAnyway;

  /// Timeframe tile label
  ///
  /// In en, this message translates to:
  /// **'Later today'**
  String get laterTodayLabel;

  /// Timeframe tile subtitle
  ///
  /// In en, this message translates to:
  /// **'Soon-ish'**
  String get laterTodaySubtitle;

  /// Timeframe tile label
  ///
  /// In en, this message translates to:
  /// **'Next few days'**
  String get nextFewDaysLabel;

  /// Timeframe tile subtitle
  ///
  /// In en, this message translates to:
  /// **'Not right now'**
  String get nextFewDaysSubtitle;

  /// Timeframe tile label
  ///
  /// In en, this message translates to:
  /// **'Next weeks'**
  String get nextWeeksLabel;

  /// Timeframe tile subtitle
  ///
  /// In en, this message translates to:
  /// **'When life calms down'**
  String get nextWeeksSubtitle;

  /// Timeframe tile label
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get nextMonthLabel;

  /// Timeframe tile subtitle
  ///
  /// In en, this message translates to:
  /// **'Future me problem'**
  String get nextMonthSubtitle;

  /// Title on the update wall screen
  ///
  /// In en, this message translates to:
  /// **'Update Required'**
  String get updateRequired;

  /// Body text on the update wall screen
  ///
  /// In en, this message translates to:
  /// **'A new version of Remind Me Later is available. Please update to the latest version to continue using the app.'**
  String get updateMessage;

  /// Button on the update wall screen
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get updateNow;

  /// Comfort hours warning: minutes remaining in overnight window
  ///
  /// In en, this message translates to:
  /// **'Only {remaining} minute{plural} left in your overnight comfort window. Send it before your window closes, or push it to tonight?'**
  String warningMinutesLeft(int remaining, String plural);

  /// Comfort hours warning: window hasn't started yet
  ///
  /// In en, this message translates to:
  /// **'Your comfort hours haven\'t kicked in yet — they start at {startTime}. Want this alert to fire outside your quiet window anyway?'**
  String warningNotStarted(String startTime);

  /// Comfort hours warning: window has already ended today
  ///
  /// In en, this message translates to:
  /// **'You\'re currently outside your comfort hours — they ended at {endTime} today. Send the alert today anyway, or reschedule it for tomorrow morning?'**
  String warningEnded(String endTime);

  /// Comfort hours warning: window is almost over
  ///
  /// In en, this message translates to:
  /// **'Only {remaining} minute{plural} left in your comfort window. The reminder might arrive right as your quiet time starts. Send it today anyway, or push it to tomorrow morning?'**
  String warningAlmostOver(int remaining, String plural);

  /// Title of the accessibility details modal
  ///
  /// In en, this message translates to:
  /// **'Accessibility Information'**
  String get accessibilityTitle;

  /// Menu button to open accessibility details
  ///
  /// In en, this message translates to:
  /// **'Accessibility Info'**
  String get accessibilityButton;

  /// Legal exemption notice for indie/small businesses
  ///
  /// In en, this message translates to:
  /// **'Accessibility Exemption Notice:\n\nRemind Me Later is developed by a sole independent developer. Our annual revenue falls below the statutory threshold requiring mandatory commercial digital accessibility adaptations.\n\nNevertheless, we believe in inclusivity and have voluntarily made an effort to implement screen reader compatibility, dynamic font scaling, and high-contrast themes. If you experience issues, please contact us and we will do our best to improve them.'**
  String get accessibilityExemptionText;

  /// Close button for accessibility dialog
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get accessibilityClose;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'he',
        'ja',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'he':
      return AppLocalizationsHe();
    case 'ja':
      return AppLocalizationsJa();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
