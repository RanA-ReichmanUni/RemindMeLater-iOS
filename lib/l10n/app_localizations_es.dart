// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get tagline => 'Te avisaremos más tarde, cuando sea más conveniente.';

  @override
  String get dumpInputHeader => 'Vuelca tu caos aquí';

  @override
  String get dumpHintText => '¿Qué tienes en mente?';

  @override
  String get timingVibeLabel => 'Momento ideal';

  @override
  String get remindMeLaterBtn => 'Recuérdamelo después';

  @override
  String get clearDraft => 'Borrar borrador';

  @override
  String get gotIt => '¡Entendido!';

  @override
  String get wellRemindYouLater => 'Te recordaremos más tarde 🤙';

  @override
  String get tabDump => 'Volcar';

  @override
  String get tabReminders => 'Recordatorios';

  @override
  String get menuLabel => 'Menú';

  @override
  String get menuOptions => 'Opciones';

  @override
  String get backgroundAnimation => 'Animación de fondo';

  @override
  String get backgroundAnimationSubtitle =>
      'Movimiento sutil detrás de la pantalla principal';

  @override
  String get onLabel => 'Activar';

  @override
  String get offLabel => 'Desactivar';

  @override
  String get legalLabel => 'Legal';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get termsLabel => 'Términos';

  @override
  String get dumpForgetHeader => 'VUELCA Y OLVIDA';

  @override
  String get chaosQueue => 'Cola de caos';

  @override
  String get trackingOne => 'Estoy rastreando 1 cosa para ti';

  @override
  String trackingCount(int count) {
    return 'Estoy rastreando $count cosas para ti';
  }

  @override
  String comfortWindowLabel(String start, String end) {
    return 'Comodidad $start - $end';
  }

  @override
  String loadMore(int remaining) {
    return 'Cargar más ($remaining restantes)';
  }

  @override
  String get markAsHandled => '¿Marcar como gestionado?';

  @override
  String get markHandledBody =>
      'Este recordatorio se eliminará de tu cola activa.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get yesHandled => 'Sí, gestionado';

  @override
  String get handled => 'Gestionado';

  @override
  String get delay => 'Posponer';

  @override
  String get close => 'Cerrar';

  @override
  String get coolKickTo => 'Genial, moverlo a:';

  @override
  String get zeroChaosin => 'Sin caos en la cola';

  @override
  String get brainDumpOther =>
      'Vuelca en la otra pestaña. Yo me encargo de ahí.';

  @override
  String get youWantedReminded => 'Querías que te recordara esto.';

  @override
  String get doneBtn => '✓  Hecho';

  @override
  String get snoozeBtn => '💤  Posponer';

  @override
  String get cancelSnooze => '✕  Cancelar';

  @override
  String get snoozeUntil => 'Posponer hasta…';

  @override
  String get snoozeLaterToday => '⚡ Más tarde hoy';

  @override
  String get snoozeTomorrow => '🌅 Mañana';

  @override
  String get snoozeNextFewDays => '🌤 Próximos días';

  @override
  String get snoozeNextWeeks => '🌙 Próximas semanas';

  @override
  String get snoozeNextMonth => '🌊 Próximo mes';

  @override
  String get comfortHoursTitle => 'Horas de comodidad';

  @override
  String get comfortHoursSubtitle =>
      'Solo enviaremos recordatorios durante estas horas, para no molestarte fuera de tu día.';

  @override
  String get fromLabel => 'Desde';

  @override
  String get untilLabel => 'Hasta';

  @override
  String get spansOvernight =>
      'Abarca la noche — la ventana de comodidad cruza la medianoche (turno nocturno).';

  @override
  String get saveBtn => 'Guardar';

  @override
  String get timingVibeTitle => 'Momento ideal';

  @override
  String get timingVibeSubtitle => '¿Cuándo debería ocuparse tu yo del futuro?';

  @override
  String get outsideComfortHours => 'Fuera de tus horas de comodidad';

  @override
  String get scheduleForTomorrow => 'Programar para mañana';

  @override
  String get alertMeAnyway => 'Avisarme de todas formas';

  @override
  String get laterTodayLabel => 'Más tarde hoy';

  @override
  String get laterTodaySubtitle => 'Pronto';

  @override
  String get nextFewDaysLabel => 'Próximos días';

  @override
  String get nextFewDaysSubtitle => 'No ahora mismo';

  @override
  String get nextWeeksLabel => 'Próximas semanas';

  @override
  String get nextWeeksSubtitle => 'Cuando la vida se calme';

  @override
  String get nextMonthLabel => 'Próximo mes';

  @override
  String get nextMonthSubtitle => 'Problema del yo futuro';

  @override
  String get updateRequired => 'Actualización requerida';

  @override
  String get updateMessage =>
      'Hay una nueva versión de Remind Me Later disponible. Por favor, actualiza a la última versión para seguir usando la app.';

  @override
  String get updateNow => 'Actualizar ahora';

  @override
  String warningMinutesLeft(int remaining, String plural) {
    return 'Solo quedan $remaining minuto$plural en tu ventana nocturna. Envíalo antes de que cierre, ¿o lo dejamos para esta noche?';
  }

  @override
  String warningNotStarted(String startTime) {
    return 'Tus horas de comodidad aún no han comenzado — empiezan a las $startTime. ¿Quieres que esta alerta se active fuera de tu ventana tranquila?';
  }

  @override
  String warningEnded(String endTime) {
    return 'Actualmente estás fuera de tus horas de comodidad — terminaron a las $endTime de hoy. ¿Enviar la alerta hoy de todas formas, o reprogramarla para mañana por la mañana?';
  }

  @override
  String warningAlmostOver(int remaining, String plural) {
    return 'Solo quedan $remaining minuto$plural en tu ventana de comodidad. El recordatorio podría llegar justo cuando empieza tu tiempo tranquilo. ¿Enviarlo hoy de todas formas, o dejarlo para mañana?';
  }
}
