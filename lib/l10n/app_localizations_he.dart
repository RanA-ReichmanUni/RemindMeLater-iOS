// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get tagline => 'נזכיר לך מאוחר יותר, כשיהיה מתאים בשבילך.';

  @override
  String get dumpInputHeader => 'פרוק את הבלגן שלך כאן';

  @override
  String get dumpHintText => 'מה עולה לך בראש?';

  @override
  String get timingVibeLabel => 'מתי הכי מתאים ?';

  @override
  String get remindMeLaterBtn => 'תזכיר לי אחר כך';

  @override
  String get clearDraft => 'מחק טיוטה';

  @override
  String get gotIt => 'הבנתי!';

  @override
  String get wellRemindYouLater => 'נזכיר לך אחר כך 🤙';

  @override
  String get tabDump => 'פרוק';

  @override
  String get tabReminders => 'תזכורות';

  @override
  String get menuLabel => 'תפריט';

  @override
  String get menuOptions => 'אפשרויות';

  @override
  String get backgroundAnimation => 'אנימציית רקע';

  @override
  String get backgroundAnimationSubtitle => 'תנועה עדינה מאחורי מסך הפריקה';

  @override
  String get onLabel => 'פועל';

  @override
  String get offLabel => 'כבוי';

  @override
  String get legalLabel => 'משפטי';

  @override
  String get privacyPolicy => 'מדיניות פרטיות';

  @override
  String get termsLabel => 'תנאי שימוש';

  @override
  String get dumpForgetHeader => 'פרוק ושכח';

  @override
  String get chaosQueue => 'תור הבלגן';

  @override
  String get trackingOne => 'אני עוקב אחרי דבר אחד בשבילך';

  @override
  String trackingCount(int count) {
    return 'אני עוקב אחרי $count דברים בשבילך';
  }

  @override
  String comfortWindowLabel(String start, String end) {
    return 'שעות נוחות $start - $end';
  }

  @override
  String loadMore(int remaining) {
    return 'טען עוד ($remaining נותרו)';
  }

  @override
  String get markAsHandled => 'לסמן כטופל?';

  @override
  String get markHandledBody => 'תזכורת זו תוסר מהתור הפעיל שלך.';

  @override
  String get cancel => 'ביטול';

  @override
  String get yesHandled => 'כן, טופל';

  @override
  String get handled => 'טופל';

  @override
  String get delay => 'דחה';

  @override
  String get close => 'סגור';

  @override
  String get coolKickTo => 'מגניב, להעביר ל:';

  @override
  String get zeroChaosin => 'אפס בלגן בתור';

  @override
  String get brainDumpOther => 'פרוק בכרטיסייה האחרת. משם כבר אזכיר לך.';

  @override
  String get youWantedReminded => 'רצית שיזכירו לך על זה.';

  @override
  String get doneBtn => '✓  סיום';

  @override
  String get snoozeBtn => '💤  נודניק';

  @override
  String get cancelSnooze => '✕  ביטול';

  @override
  String get snoozeUntil => 'דחה עד…';

  @override
  String get snoozeLaterToday => '⚡ מאוחר יותר היום';

  @override
  String get snoozeTomorrow => '🌅 מחר';

  @override
  String get snoozeNextFewDays => '🌤 בימים הקרובים';

  @override
  String get snoozeNextWeeks => '🌙 בשבועות הקרובים';

  @override
  String get snoozeNextMonth => '🌊 בחודש הבא';

  @override
  String get comfortHoursTitle => 'שעות נוחות';

  @override
  String get comfortHoursSubtitle =>
      'נשלח תזכורות רק בשעות אלו, כדי שלא נפריע לך מחוץ לשגרת יומך.';

  @override
  String get fromLabel => 'מ־';

  @override
  String get untilLabel => 'עד';

  @override
  String get spansOvernight =>
      'חוצה לילה — חלון הנוחות עובר חצות (משמרת לילה).';

  @override
  String get saveBtn => 'שמור';

  @override
  String get timingVibeTitle => 'מתי מתאים?';

  @override
  String get timingVibeSubtitle => 'מתי אתה-העתידי אמור להתעסק בזה?';

  @override
  String get outsideComfortHours => 'מחוץ לשעות הנוחות שלך';

  @override
  String get scheduleForTomorrow => 'תזמן למחר';

  @override
  String get alertMeAnyway => 'התרע בכל זאת';

  @override
  String get laterTodayLabel => 'מאוחר יותר היום';

  @override
  String get laterTodaySubtitle => 'בקרוב';

  @override
  String get nextFewDaysLabel => 'בימים הקרובים';

  @override
  String get nextFewDaysSubtitle => 'לא עכשיו';

  @override
  String get nextWeeksLabel => 'בשבועות הקרובים';

  @override
  String get nextWeeksSubtitle => 'כשהחיים ירגעו';

  @override
  String get nextMonthLabel => 'בחודש הבא';

  @override
  String get nextMonthSubtitle => 'בעיה של אני-העתידי';

  @override
  String get updateRequired => 'נדרש עדכון';

  @override
  String get updateMessage =>
      'גרסה חדשה של Remind Me Later זמינה. אנא עדכן לגרסה האחרונה כדי להמשיך להשתמש באפליקציה.';

  @override
  String get updateNow => 'עדכן עכשיו';

  @override
  String warningMinutesLeft(int remaining, String plural) {
    return 'נותרו רק $remaining דקו$plural בחלון הלילה שלך. שלח לפני שהחלון נסגר, או דחה להלילה?';
  }

  @override
  String warningNotStarted(String startTime) {
    return 'שעות הנוחות עוד לא התחילו — הן מתחילות ב‑$startTime. האם להפעיל את ההתראה בכל זאת מחוץ לחלון השקט?';
  }

  @override
  String warningEnded(String endTime) {
    return 'כרגע אתה מחוץ לשעות הנוחות — הן הסתיימו היום ב‑$endTime. לשלוח את ההתראה היום בכל זאת, או לתזמן מחדש למחר בבוקר?';
  }

  @override
  String warningAlmostOver(int remaining, String plural) {
    return 'נותרו רק $remaining דקו$plural בחלון הנוחות שלך. התזכורת עשויה להגיע ממש בתחילת זמן השקט שלך. לשלוח היום בכל זאת, או לדחות למחר?';
  }

  @override
  String get accessibilityTitle => 'מידע נגישות';

  @override
  String get accessibilityButton => 'מידע נגישות';

  @override
  String get accessibilityExemptionText =>
      'הצהרת פטור מנגישות:\n\nהאפליקציה Remind Me Later מפותחת על ידי מפתח עצמאי יחיד. ההכנסה השנתית שלנו נמוכה מהסף החוקי המחייב התאמות נגישות דיגיטלית מסחריות לפי חוקי. \n\nעם זאת, אנו מאמינים בשוויון ונעשה מאמץ להטמיע בהתנדבות תאימות לקוראי מסך, התאמה לגודל גופן דינמי וערכות נושא בניגודיות גבוהה. אם נתקלתם בבעיה, אנא פנו אלינו ונעשה כמיטב יכולתנו לשפרה.';

  @override
  String get accessibilityClose => 'סגור';
}
