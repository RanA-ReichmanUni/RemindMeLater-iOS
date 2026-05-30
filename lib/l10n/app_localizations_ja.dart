// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get tagline => '都合のいいときに、後でお知らせします。';

  @override
  String get dumpInputHeader => 'ここに頭の中を吐き出して';

  @override
  String get dumpHintText => '何が気になっていますか？';

  @override
  String get timingVibeLabel => 'タイミング';

  @override
  String get remindMeLaterBtn => '後で思い出させて';

  @override
  String get clearDraft => '下書きを消去';

  @override
  String get gotIt => '了解！';

  @override
  String get wellRemindYouLater => '後で思い出させますね 🤙';

  @override
  String get tabDump => '書き出す';

  @override
  String get tabReminders => 'リマインダー';

  @override
  String get menuLabel => 'メニュー';

  @override
  String get menuOptions => 'オプション';

  @override
  String get backgroundAnimation => '背景アニメーション';

  @override
  String get backgroundAnimationSubtitle => 'メイン画面の背後で動く微妙なモーション';

  @override
  String get onLabel => 'オン';

  @override
  String get offLabel => 'オフ';

  @override
  String get legalLabel => '法的情報';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get termsLabel => '利用規約';

  @override
  String get dumpForgetHeader => '書き出して忘れる';

  @override
  String get chaosQueue => 'カオスキュー';

  @override
  String get trackingOne => 'あなたのために1件管理しています';

  @override
  String trackingCount(int count) {
    return 'あなたのために$count件管理しています';
  }

  @override
  String comfortWindowLabel(String start, String end) {
    return '快適時間 $start - $end';
  }

  @override
  String loadMore(int remaining) {
    return 'さらに読み込む（残り$remaining件）';
  }

  @override
  String get markAsHandled => '処理済みにしますか？';

  @override
  String get markHandledBody => 'このリマインダーはアクティブなキューから削除されます。';

  @override
  String get cancel => 'キャンセル';

  @override
  String get yesHandled => 'はい、処理済みです';

  @override
  String get handled => '処理済み';

  @override
  String get delay => '先延ばし';

  @override
  String get close => '閉じる';

  @override
  String get coolKickTo => 'いいね、次の時期に：';

  @override
  String get zeroChaosin => 'キューにカオスなし';

  @override
  String get brainDumpOther => '別のタブで書き出してください。後はお任せを。';

  @override
  String get youWantedReminded => 'これについてリマインドをお願いしていましたね。';

  @override
  String get doneBtn => '✓  完了';

  @override
  String get snoozeBtn => '💤  スヌーズ';

  @override
  String get cancelSnooze => '✕  キャンセル';

  @override
  String get snoozeUntil => 'スヌーズする期間…';

  @override
  String get snoozeLaterToday => '⚡ 今日の後で';

  @override
  String get snoozeTomorrow => '🌅 明日';

  @override
  String get snoozeNextFewDays => '🌤 数日後';

  @override
  String get snoozeNextWeeks => '🌙 数週間後';

  @override
  String get snoozeNextMonth => '🌊 来月';

  @override
  String get comfortHoursTitle => '快適時間';

  @override
  String get comfortHoursSubtitle => 'この時間帯にのみリマインダーを送信します。日常の時間外は通知しません。';

  @override
  String get fromLabel => '開始';

  @override
  String get untilLabel => '終了';

  @override
  String get spansOvernight => '深夜をまたぎます — 快適時間が真夜中を超えています（夜勤シフト）。';

  @override
  String get saveBtn => '保存';

  @override
  String get timingVibeTitle => 'タイミング';

  @override
  String get timingVibeSubtitle => '未来のあなたはいつ対処しますか？';

  @override
  String get outsideComfortHours => '快適時間外です';

  @override
  String get scheduleForTomorrow => '明日にスケジュール';

  @override
  String get alertMeAnyway => 'とにかく通知して';

  @override
  String get laterTodayLabel => '今日の後で';

  @override
  String get laterTodaySubtitle => 'もうすぐ';

  @override
  String get nextFewDaysLabel => '数日後';

  @override
  String get nextFewDaysSubtitle => '今はまだ';

  @override
  String get nextWeeksLabel => '数週間後';

  @override
  String get nextWeeksSubtitle => '生活が落ち着いたら';

  @override
  String get nextMonthLabel => '来月';

  @override
  String get nextMonthSubtitle => '未来の自分に任せた';

  @override
  String get updateRequired => 'アップデートが必要です';

  @override
  String get updateMessage =>
      'Remind Me Laterの新しいバージョンが利用可能です。引き続きアプリをご利用いただくために、最新バージョンに更新してください。';

  @override
  String get updateNow => '今すぐ更新';

  @override
  String warningMinutesLeft(int remaining, String plural) {
    return '深夜の快適ウィンドウに残り$remaining分$pluralしかありません。ウィンドウが閉じる前に送るか、今夜に先延ばしますか？';
  }

  @override
  String warningNotStarted(String startTime) {
    return '快適時間はまだ始まっていません — $startTimeに開始します。静かな時間外でもこのアラートを送りますか？';
  }

  @override
  String warningEnded(String endTime) {
    return '現在は快適時間外です — 今日の$endTimeに終了しました。今日送るか、明朝に再スケジュールしますか？';
  }

  @override
  String warningAlmostOver(int remaining, String plural) {
    return '快適ウィンドウに残り$remaining分$pluralしかありません。静かな時間が始まる直前にリマインダーが届くかもしれません。今日送りますか、それとも明日に先延ばしますか？';
  }
}
