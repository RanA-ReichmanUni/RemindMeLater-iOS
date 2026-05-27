enum Timeframe {
  laterToday('Later today', 0, 0),
  nextFewDays('Next few days', 1, 4),
  nextWeeks('Next weeks', 7, 21),
  nextMonth('Next month', 22, 45);

  final String label;
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
