// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get tagline => '我们稍后会提醒你，在更方便的时候。';

  @override
  String get dumpInputHeader => '把你的烦恼倾泻在这里';

  @override
  String get dumpHintText => '你在想什么？';

  @override
  String get timingVibeLabel => '提醒时机';

  @override
  String get remindMeLaterBtn => '稍后提醒我';

  @override
  String get clearDraft => '清除草稿';

  @override
  String get gotIt => '明白了！';

  @override
  String get wellRemindYouLater => '稍后提醒你 🤙';

  @override
  String get tabDump => '倾诉';

  @override
  String get tabReminders => '提醒事项';

  @override
  String get menuLabel => '菜单';

  @override
  String get menuOptions => '选项';

  @override
  String get backgroundAnimation => '背景动画';

  @override
  String get backgroundAnimationSubtitle => '主屏幕后的细微动态效果';

  @override
  String get onLabel => '开启';

  @override
  String get offLabel => '关闭';

  @override
  String get legalLabel => '法律信息';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get termsLabel => '条款';

  @override
  String get dumpForgetHeader => '倾诉并忘记';

  @override
  String get chaosQueue => '混乱队列';

  @override
  String get trackingOne => '我正在为你追踪 1 件事';

  @override
  String trackingCount(int count) {
    return '我正在为你追踪 $count 件事';
  }

  @override
  String comfortWindowLabel(String start, String end) {
    return '舒适时段 $start - $end';
  }

  @override
  String loadMore(int remaining) {
    return '加载更多（剩余 $remaining 条）';
  }

  @override
  String get markAsHandled => '标记为已处理？';

  @override
  String get markHandledBody => '此提醒将从你的活动队列中移除。';

  @override
  String get cancel => '取消';

  @override
  String get yesHandled => '是的，已处理';

  @override
  String get handled => '已处理';

  @override
  String get delay => '推迟';

  @override
  String get close => '关闭';

  @override
  String get coolKickTo => '好的，推迟到：';

  @override
  String get zeroChaosin => '队列中没有混乱';

  @override
  String get brainDumpOther => '在另一个标签中倾诉吧。剩下的交给我。';

  @override
  String get youWantedReminded => '你曾希望被提醒这件事。';

  @override
  String get doneBtn => '✓  完成';

  @override
  String get snoozeBtn => '💤  稍后提醒';

  @override
  String get cancelSnooze => '✕  取消';

  @override
  String get snoozeUntil => '推迟提醒至…';

  @override
  String get snoozeLaterToday => '⚡ 今天晚些时候';

  @override
  String get snoozeTomorrow => '🌅 明天';

  @override
  String get snoozeNextFewDays => '🌤 接下来几天';

  @override
  String get snoozeNextWeeks => '🌙 接下来几周';

  @override
  String get snoozeNextMonth => '🌊 下个月';

  @override
  String get comfortHoursTitle => '舒适时段';

  @override
  String get comfortHoursSubtitle => '我们只会在这些时间段内发送提醒，不会在你的日常时间外打扰你。';

  @override
  String get fromLabel => '从';

  @override
  String get untilLabel => '到';

  @override
  String get spansOvernight => '跨越夜晚 — 舒适时段超过午夜（夜班模式）。';

  @override
  String get saveBtn => '保存';

  @override
  String get timingVibeTitle => '提醒时机';

  @override
  String get timingVibeSubtitle => '未来的你应该什么时候处理这件事？';

  @override
  String get outsideComfortHours => '在你的舒适时段之外';

  @override
  String get scheduleForTomorrow => '安排在明天';

  @override
  String get alertMeAnyway => '无论如何提醒我';

  @override
  String get laterTodayLabel => '今天晚些时候';

  @override
  String get laterTodaySubtitle => '很快';

  @override
  String get nextFewDaysLabel => '接下来几天';

  @override
  String get nextFewDaysSubtitle => '现在不行';

  @override
  String get nextWeeksLabel => '接下来几周';

  @override
  String get nextWeeksSubtitle => '等生活平静下来';

  @override
  String get nextMonthLabel => '下个月';

  @override
  String get nextMonthSubtitle => '留给未来的我';

  @override
  String get updateRequired => '需要更新';

  @override
  String get updateMessage => 'Remind Me Later 有新版本可用。请更新到最新版本以继续使用该应用。';

  @override
  String get updateNow => '立即更新';

  @override
  String warningMinutesLeft(int remaining, String plural) {
    return '你的夜间舒适时段仅剩 $remaining 分钟$plural。在时段结束前发送，还是推迟到今晚？';
  }

  @override
  String warningNotStarted(String startTime) {
    return '你的舒适时段尚未开始 — 将于 $startTime 开始。是否在安静时段外触发此提醒？';
  }

  @override
  String warningEnded(String endTime) {
    return '你目前在舒适时段之外 — 今天 $endTime 已结束。现在发送提醒，还是重新安排到明天早上？';
  }

  @override
  String warningAlmostOver(int remaining, String plural) {
    return '舒适时段仅剩 $remaining 分钟$plural。提醒可能正好在你的安静时间开始时到达。今天发送，还是推迟到明天？';
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
