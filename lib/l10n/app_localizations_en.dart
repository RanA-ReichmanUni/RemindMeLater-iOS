// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tagline => 'We\'ll ping you later, when it\'s more convenient.';

  @override
  String get dumpInputHeader => 'Dump your chaos here';

  @override
  String get dumpHintText => 'What\'s on your mind?';

  @override
  String get timingVibeLabel => 'Timing vibe';

  @override
  String get remindMeLaterBtn => 'Remind Me Later';

  @override
  String get clearDraft => 'Clear draft';

  @override
  String get gotIt => 'Got it!';

  @override
  String get wellRemindYouLater => 'We\'ll remind you later 🤙';

  @override
  String get tabDump => 'Dump';

  @override
  String get tabReminders => 'Reminders';

  @override
  String get menuLabel => 'Menu';

  @override
  String get menuOptions => 'Options';

  @override
  String get backgroundAnimation => 'Background animation';

  @override
  String get backgroundAnimationSubtitle =>
      'Subtle motion behind the dump screen';

  @override
  String get onLabel => 'On';

  @override
  String get offLabel => 'Off';

  @override
  String get legalLabel => 'Legal';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsLabel => 'Terms';

  @override
  String get dumpForgetHeader => 'DUMP & FORGET';

  @override
  String get chaosQueue => 'Chaos queue';

  @override
  String get trackingOne => 'I\'m tracking 1 thing for you';

  @override
  String trackingCount(int count) {
    return 'I\'m tracking $count things for you';
  }

  @override
  String comfortWindowLabel(String start, String end) {
    return 'Comfort $start - $end';
  }

  @override
  String loadMore(int remaining) {
    return 'Load more ($remaining remaining)';
  }

  @override
  String get markAsHandled => 'Mark as handled?';

  @override
  String get markHandledBody =>
      'This reminder will be removed from your active queue.';

  @override
  String get cancel => 'Cancel';

  @override
  String get yesHandled => 'Yes, handled';

  @override
  String get handled => 'Handled';

  @override
  String get delay => 'Delay';

  @override
  String get close => 'Close';

  @override
  String get coolKickTo => 'Cool, kick it to:';

  @override
  String get zeroChaosin => 'Zero chaos in the queue';

  @override
  String get brainDumpOther =>
      'Brain-dump on the other tab. I\'ll take it from there.';

  @override
  String get youWantedReminded => 'You wanted to be reminded about this.';

  @override
  String get doneBtn => '✓  Done';

  @override
  String get snoozeBtn => '💤  Snooze';

  @override
  String get cancelSnooze => '✕  Cancel';

  @override
  String get snoozeUntil => 'Snooze until…';

  @override
  String get snoozeLaterToday => '⚡ Later today';

  @override
  String get snoozeTomorrow => '🌅 Tomorrow';

  @override
  String get snoozeNextFewDays => '🌤 Next few days';

  @override
  String get snoozeNextWeeks => '🌙 Next weeks';

  @override
  String get snoozeNextMonth => '🌊 Next month';

  @override
  String get comfortHoursTitle => 'Comfort hours';

  @override
  String get comfortHoursSubtitle =>
      'We\'ll only send reminders during these hours — so you\'re never bothered outside your day.';

  @override
  String get fromLabel => 'From';

  @override
  String get untilLabel => 'Until';

  @override
  String get spansOvernight =>
      'Spans overnight — comfort window crosses midnight (night shift).';

  @override
  String get saveBtn => 'Save';

  @override
  String get timingVibeTitle => 'Timing vibe';

  @override
  String get timingVibeSubtitle => 'When should future-you deal with this?';

  @override
  String get outsideComfortHours => 'Outside your comfort hours';

  @override
  String get scheduleForTomorrow => 'Schedule for tomorrow';

  @override
  String get alertMeAnyway => 'Alert me anyway';

  @override
  String get laterTodayLabel => 'Later today';

  @override
  String get laterTodaySubtitle => 'Soon-ish';

  @override
  String get nextFewDaysLabel => 'Next few days';

  @override
  String get nextFewDaysSubtitle => 'Not right now';

  @override
  String get nextWeeksLabel => 'Next weeks';

  @override
  String get nextWeeksSubtitle => 'When life calms down';

  @override
  String get nextMonthLabel => 'Next month';

  @override
  String get nextMonthSubtitle => 'Future me problem';

  @override
  String get updateRequired => 'Update Required';

  @override
  String get updateMessage =>
      'A new version of Remind Me Later is available. Please update to the latest version to continue using the app.';

  @override
  String get updateNow => 'Update Now';

  @override
  String warningMinutesLeft(int remaining, String plural) {
    return 'Only $remaining minute$plural left in your overnight comfort window. Send it before your window closes, or push it to tonight?';
  }

  @override
  String warningNotStarted(String startTime) {
    return 'Your comfort hours haven\'t kicked in yet — they start at $startTime. Want this alert to fire outside your quiet window anyway?';
  }

  @override
  String warningEnded(String endTime) {
    return 'You\'re currently outside your comfort hours — they ended at $endTime today. Send the alert today anyway, or reschedule it for tomorrow morning?';
  }

  @override
  String warningAlmostOver(int remaining, String plural) {
    return 'Only $remaining minute$plural left in your comfort window. The reminder might arrive right as your quiet time starts. Send it today anyway, or push it to tomorrow morning?';
  }

  @override
  String get accessibilityTitle => 'Accessibility Information';

  @override
  String get accessibilityButton => 'Accessibility Info';

  @override
  String get accessibilityExemptionText =>
      'Accessibility Exemption Notice:\n\nRemind Me Later is developed by a sole independent developer. Our annual revenue falls below the statutory threshold requiring mandatory commercial digital accessibility adaptations.\n\nNevertheless, we believe in inclusivity and have voluntarily made an effort to implement screen reader compatibility, dynamic font scaling, and high-contrast themes. If you experience issues, please contact us and we will do our best to improve them.';

  @override
  String get accessibilityClose => 'Close';
}
