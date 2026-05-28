import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum Timeframe {
  laterToday('Later today', 0, 0),
  nextFewDays('Next few days', 1, 4),
  nextWeeks('Next weeks', 7, 21),
  nextMonth('Next month', 22, 45);

  final String label; // retained for DB serialization — do NOT translate
  final int minDays;
  final int maxDays;

  const Timeframe(this.label, this.minDays, this.maxDays);

  // String serialization/deserialization matching Android Room values (enum names)
  String toDbValue() {
    switch (this) {
      case Timeframe.laterToday:
        return 'LATER_TODAY';
      case Timeframe.nextFewDays:
        return 'NEXT_FEW_DAYS';
      case Timeframe.nextWeeks:
        return 'NEXT_WEEKS';
      case Timeframe.nextMonth:
        return 'NEXT_MONTH';
    }
  }

  static Timeframe fromDbValue(String value) {
    switch (value) {
      case 'LATER_TODAY':
        return Timeframe.laterToday;
      case 'NEXT_FEW_DAYS':
        return Timeframe.nextFewDays;
      case 'NEXT_WEEKS':
        return Timeframe.nextWeeks;
      case 'NEXT_MONTH':
      default:
        return Timeframe.nextMonth;
    }
  }
}

// ---------------------------------------------------------------------------
// Localized display labels — use this in UI instead of .label
// ---------------------------------------------------------------------------
extension TimeframeLocalization on Timeframe {
  String get emoji {
    switch (this) {
      case Timeframe.laterToday:
        return '⚡';
      case Timeframe.nextFewDays:
        return '🌤';
      case Timeframe.nextWeeks:
        return '🌙';
      case Timeframe.nextMonth:
        return '🌊';
    }
  }

  String localizedLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case Timeframe.laterToday:
        return l10n.laterTodayLabel;
      case Timeframe.nextFewDays:
        return l10n.nextFewDaysLabel;
      case Timeframe.nextWeeks:
        return l10n.nextWeeksLabel;
      case Timeframe.nextMonth:
        return l10n.nextMonthLabel;
    }
  }

  String localizedSubtitle(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case Timeframe.laterToday:
        return l10n.laterTodaySubtitle;
      case Timeframe.nextFewDays:
        return l10n.nextFewDaysSubtitle;
      case Timeframe.nextWeeks:
        return l10n.nextWeeksSubtitle;
      case Timeframe.nextMonth:
        return l10n.nextMonthSubtitle;
    }
  }
}
