import 'timeframe.dart';

enum ReminderStatus {
  pending,
  done,
  snoozed;

  String toDbValue() {
    switch (this) {
      case ReminderStatus.pending:
        return 'PENDING';
      case ReminderStatus.done:
        return 'DONE';
      case ReminderStatus.snoozed:
        return 'SNOOZED';
    }
  }

  static ReminderStatus fromDbValue(String value) {
    switch (value) {
      case 'PENDING':
        return ReminderStatus.pending;
      case 'DONE':
        return ReminderStatus.done;
      case 'SNOOZED':
      default:
        return ReminderStatus.snoozed;
    }
  }
}

class Reminder {
  final int? id;
  final String text;
  final Timeframe timeframe;
  final int scheduledAt; // epoch ms
  final ReminderStatus status;
  final int createdAt; // epoch ms

  Reminder({
    this.id,
    required this.text,
    required this.timeframe,
    required this.scheduledAt,
    this.status = ReminderStatus.pending,
    int? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  Reminder copyWith({
    int? id,
    String? text,
    Timeframe? timeframe,
    int? scheduledAt,
    ReminderStatus? status,
    int? createdAt,
  }) {
    return Reminder(
      id: id ?? this.id,
      text: text ?? this.text,
      timeframe: timeframe ?? this.timeframe,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'text': text,
      'timeframe': timeframe.toDbValue(),
      'scheduledAt': scheduledAt,
      'status': status.toDbValue(),
      'createdAt': createdAt,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'] as int?,
      text: map['text'] as String,
      timeframe: Timeframe.fromDbValue(map['timeframe'] as String),
      scheduledAt: map['scheduledAt'] as int,
      status: ReminderStatus.fromDbValue(map['status'] as String),
      createdAt: map['createdAt'] as int,
    );
  }
}
