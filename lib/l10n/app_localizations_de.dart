// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get tagline => 'Wir erinnern dich später, wenn es besser passt.';

  @override
  String get dumpInputHeader => 'Wirf dein Chaos hier ab';

  @override
  String get dumpHintText => 'Was beschäftigt dich?';

  @override
  String get timingVibeLabel => 'Timing-Vibe';

  @override
  String get remindMeLaterBtn => 'Erinnere mich später';

  @override
  String get clearDraft => 'Entwurf löschen';

  @override
  String get gotIt => 'Verstanden!';

  @override
  String get wellRemindYouLater => 'Wir erinnern dich später 🤙';

  @override
  String get tabDump => 'Abladen';

  @override
  String get tabReminders => 'Erinnerungen';

  @override
  String get menuLabel => 'Menü';

  @override
  String get menuOptions => 'Optionen';

  @override
  String get backgroundAnimation => 'Hintergrundanimation';

  @override
  String get backgroundAnimationSubtitle =>
      'Subtile Bewegung hinter dem Hauptbildschirm';

  @override
  String get onLabel => 'Ein';

  @override
  String get offLabel => 'Aus';

  @override
  String get legalLabel => 'Rechtliches';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get termsLabel => 'Nutzungsbedingungen';

  @override
  String get dumpForgetHeader => 'ABLADEN & VERGESSEN';

  @override
  String get chaosQueue => 'Chaos-Warteschlange';

  @override
  String get trackingOne => 'Ich verfolge 1 Sache für dich';

  @override
  String trackingCount(int count) {
    return 'Ich verfolge $count Dinge für dich';
  }

  @override
  String comfortWindowLabel(String start, String end) {
    return 'Komfort $start - $end';
  }

  @override
  String loadMore(int remaining) {
    return 'Mehr laden ($remaining verbleibend)';
  }

  @override
  String get markAsHandled => 'Als erledigt markieren?';

  @override
  String get markHandledBody =>
      'Diese Erinnerung wird aus deiner aktiven Warteschlange entfernt.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get yesHandled => 'Ja, erledigt';

  @override
  String get handled => 'Erledigt';

  @override
  String get delay => 'Verschieben';

  @override
  String get close => 'Schließen';

  @override
  String get coolKickTo => 'Alles klar, verschieben zu:';

  @override
  String get zeroChaosin => 'Kein Chaos in der Warteschlange';

  @override
  String get brainDumpOther =>
      'Lade im anderen Tab ab. Den Rest übernehme ich.';

  @override
  String get youWantedReminded => 'Du wolltest daran erinnert werden.';

  @override
  String get doneBtn => '✓  Fertig';

  @override
  String get snoozeBtn => '💤  Snoozen';

  @override
  String get cancelSnooze => '✕  Abbrechen';

  @override
  String get snoozeUntil => 'Snoozen bis…';

  @override
  String get snoozeLaterToday => '⚡ Später heute';

  @override
  String get snoozeTomorrow => '🌅 Morgen';

  @override
  String get snoozeNextFewDays => '🌤 Nächste Tage';

  @override
  String get snoozeNextWeeks => '🌙 Nächste Wochen';

  @override
  String get snoozeNextMonth => '🌊 Nächsten Monat';

  @override
  String get comfortHoursTitle => 'Komfortzeiten';

  @override
  String get comfortHoursSubtitle =>
      'Wir senden Erinnerungen nur in diesen Zeiten — damit du außerhalb deines Tages nicht gestört wirst.';

  @override
  String get fromLabel => 'Von';

  @override
  String get untilLabel => 'Bis';

  @override
  String get spansOvernight =>
      'Übernacht — das Komfortfenster überschreitet Mitternacht (Nachtschicht).';

  @override
  String get saveBtn => 'Speichern';

  @override
  String get timingVibeTitle => 'Timing-Vibe';

  @override
  String get timingVibeSubtitle =>
      'Wann soll dein zukünftiges Ich damit umgehen?';

  @override
  String get outsideComfortHours => 'Außerhalb deiner Komfortzeiten';

  @override
  String get scheduleForTomorrow => 'Für morgen planen';

  @override
  String get alertMeAnyway => 'Trotzdem benachrichtigen';

  @override
  String get laterTodayLabel => 'Später heute';

  @override
  String get laterTodaySubtitle => 'Bald';

  @override
  String get nextFewDaysLabel => 'Nächste Tage';

  @override
  String get nextFewDaysSubtitle => 'Nicht jetzt';

  @override
  String get nextWeeksLabel => 'Nächste Wochen';

  @override
  String get nextWeeksSubtitle => 'Wenn das Leben ruhiger wird';

  @override
  String get nextMonthLabel => 'Nächsten Monat';

  @override
  String get nextMonthSubtitle => 'Zukünftiges-Ich-Problem';

  @override
  String get updateRequired => 'Update erforderlich';

  @override
  String get updateMessage =>
      'Eine neue Version von Remind Me Later ist verfügbar. Bitte aktualisiere auf die neueste Version, um die App weiterhin nutzen zu können.';

  @override
  String get updateNow => 'Jetzt aktualisieren';

  @override
  String warningMinutesLeft(int remaining, String plural) {
    return 'Nur noch $remaining Minute$plural in deinem Nacht-Komfortfenster. Sende es jetzt, oder push es auf heute Nacht?';
  }

  @override
  String warningNotStarted(String startTime) {
    return 'Deine Komfortzeiten haben noch nicht begonnen — sie starten um $startTime. Soll diese Benachrichtigung außerhalb deines ruhigen Fensters ausgelöst werden?';
  }

  @override
  String warningEnded(String endTime) {
    return 'Du befindest dich gerade außerhalb deiner Komfortzeiten — sie endeten heute um $endTime. Trotzdem heute senden, oder für morgen früh neu planen?';
  }

  @override
  String warningAlmostOver(int remaining, String plural) {
    return 'Nur noch $remaining Minute$plural in deinem Komfortfenster. Die Erinnerung könnte genau zu Beginn deiner ruhigen Zeit ankommen. Heute trotzdem senden, oder auf morgen verschieben?';
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
