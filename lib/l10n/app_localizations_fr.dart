// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get tagline =>
      'On vous rappellera plus tard, quand ce sera plus pratique.';

  @override
  String get dumpInputHeader => 'Déposez votre chaos ici';

  @override
  String get dumpHintText => 'À quoi pensez-vous ?';

  @override
  String get timingVibeLabel => 'Moment idéal';

  @override
  String get remindMeLaterBtn => 'Rappelle-moi plus tard';

  @override
  String get clearDraft => 'Effacer le brouillon';

  @override
  String get gotIt => 'Compris !';

  @override
  String get wellRemindYouLater => 'On vous rappellera plus tard 🤙';

  @override
  String get tabDump => 'Déposer';

  @override
  String get tabReminders => 'Rappels';

  @override
  String get menuLabel => 'Menu';

  @override
  String get menuOptions => 'Options';

  @override
  String get backgroundAnimation => 'Animation de fond';

  @override
  String get backgroundAnimationSubtitle =>
      'Mouvement subtil derrière l\'écran principal';

  @override
  String get onLabel => 'Activer';

  @override
  String get offLabel => 'Désactiver';

  @override
  String get legalLabel => 'Mentions légales';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get termsLabel => 'Conditions';

  @override
  String get dumpForgetHeader => 'DÉPOSER & OUBLIER';

  @override
  String get chaosQueue => 'File du chaos';

  @override
  String get trackingOne => 'Je suis 1 chose pour vous';

  @override
  String trackingCount(int count) {
    return 'Je suis $count choses pour vous';
  }

  @override
  String comfortWindowLabel(String start, String end) {
    return 'Confort $start - $end';
  }

  @override
  String loadMore(int remaining) {
    return 'Charger plus ($remaining restants)';
  }

  @override
  String get markAsHandled => 'Marquer comme traité ?';

  @override
  String get markHandledBody => 'Ce rappel sera retiré de votre file active.';

  @override
  String get cancel => 'Annuler';

  @override
  String get yesHandled => 'Oui, traité';

  @override
  String get handled => 'Traité';

  @override
  String get delay => 'Reporter';

  @override
  String get close => 'Fermer';

  @override
  String get coolKickTo => 'Sympa, le déplacer à :';

  @override
  String get zeroChaosin => 'Aucun chaos dans la file';

  @override
  String get brainDumpOther => 'Déposez dans l\'autre onglet. Je m\'en occupe.';

  @override
  String get youWantedReminded => 'Vous vouliez être rappelé à ce sujet.';

  @override
  String get doneBtn => '✓  Fait';

  @override
  String get snoozeBtn => '💤  Reporter';

  @override
  String get cancelSnooze => '✕  Annuler';

  @override
  String get snoozeUntil => 'Reporter jusqu\'à…';

  @override
  String get snoozeLaterToday => '⚡ Plus tard aujourd\'hui';

  @override
  String get snoozeTomorrow => '🌅 Demain';

  @override
  String get snoozeNextFewDays => '🌤 Dans quelques jours';

  @override
  String get snoozeNextWeeks => '🌙 Dans quelques semaines';

  @override
  String get snoozeNextMonth => '🌊 Le mois prochain';

  @override
  String get comfortHoursTitle => 'Heures de confort';

  @override
  String get comfortHoursSubtitle =>
      'Nous n\'enverrons des rappels que pendant ces heures — pour ne pas vous déranger en dehors de votre journée.';

  @override
  String get fromLabel => 'De';

  @override
  String get untilLabel => 'Jusqu\'à';

  @override
  String get spansOvernight =>
      'Couvre la nuit — la fenêtre de confort passe minuit (travail de nuit).';

  @override
  String get saveBtn => 'Enregistrer';

  @override
  String get timingVibeTitle => 'Moment idéal';

  @override
  String get timingVibeSubtitle =>
      'Quand votre futur moi devrait-il s\'en occuper ?';

  @override
  String get outsideComfortHours => 'En dehors de vos heures de confort';

  @override
  String get scheduleForTomorrow => 'Planifier pour demain';

  @override
  String get alertMeAnyway => 'M\'alerter quand même';

  @override
  String get laterTodayLabel => 'Plus tard aujourd\'hui';

  @override
  String get laterTodaySubtitle => 'Bientôt';

  @override
  String get nextFewDaysLabel => 'Dans quelques jours';

  @override
  String get nextFewDaysSubtitle => 'Pas maintenant';

  @override
  String get nextWeeksLabel => 'Dans quelques semaines';

  @override
  String get nextWeeksSubtitle => 'Quand la vie se calme';

  @override
  String get nextMonthLabel => 'Le mois prochain';

  @override
  String get nextMonthSubtitle => 'Problème du moi futur';

  @override
  String get updateRequired => 'Mise à jour requise';

  @override
  String get updateMessage =>
      'Une nouvelle version de Remind Me Later est disponible. Veuillez mettre à jour vers la dernière version pour continuer à utiliser l\'application.';

  @override
  String get updateNow => 'Mettre à jour';

  @override
  String warningMinutesLeft(int remaining, String plural) {
    return 'Il ne reste que $remaining minute$plural dans votre fenêtre nocturne. Envoyez-le avant que la fenêtre se ferme, ou reportez à ce soir ?';
  }

  @override
  String warningNotStarted(String startTime) {
    return 'Vos heures de confort n\'ont pas encore commencé — elles débutent à $startTime. Voulez-vous que cette alerte se déclenche en dehors de votre fenêtre ?';
  }

  @override
  String warningEnded(String endTime) {
    return 'Vous êtes actuellement hors de vos heures de confort — elles se sont terminées à $endTime aujourd\'hui. Envoyer l\'alerte quand même, ou la reprogrammer demain matin ?';
  }

  @override
  String warningAlmostOver(int remaining, String plural) {
    return 'Il ne reste que $remaining minute$plural dans votre fenêtre de confort. Le rappel pourrait arriver juste au début de votre temps calme. L\'envoyer aujourd\'hui quand même, ou le reporter à demain ?';
  }
}
