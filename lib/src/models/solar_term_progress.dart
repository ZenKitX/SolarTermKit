import 'solar_term_model.dart';

/// Solar term period (start and end dates)
class SolarTermPeriod {
  const SolarTermPeriod({
    required this.term,
    required this.startDate,
    required this.endDate,
  });

  /// Solar term
  final SolarTerm term;

  /// Start date of the period
  final DateTime startDate;

  /// End date of the period
  final DateTime endDate;

  /// Duration of the period
  Duration get duration => endDate.difference(startDate);

  /// Check if a date is within this period
  bool contains(DateTime date) {
    return date.isAfter(startDate) && date.isBefore(endDate) ||
           date.isAtSameMomentAs(startDate) ||
           date.isAtSameMomentAs(endDate);
  }

  @override
  String toString() {
    return 'SolarTermPeriod(term: ${term.name}, start: $startDate, end: $endDate)';
  }
}

/// Progress within the current solar term
class SolarTermProgress {
  const SolarTermProgress({
    required this.currentTerm,
    required this.nextTerm,
    required this.period,
    required this.percentage,
    required this.daysIntoTerm,
    required this.daysUntilNextTerm,
    required this.remainingDays,
  });

  /// Current solar term
  final SolarTerm currentTerm;

  /// Next solar term
  final SolarTerm nextTerm;

  /// Period of the current term
  final SolarTermPeriod period;

  /// Progress percentage (0.0 to 100.0)
  final double percentage;

  /// Days elapsed in the current term
  final int daysIntoTerm;

  /// Days until the next term
  final int daysUntilNextTerm;

  /// Remaining days in the current term
  final int remainingDays;

  /// Check if progress is at the beginning of the term
  bool get isBeginning => percentage < 20.0;

  /// Check if progress is near the middle of the term
  bool get isMiddle => percentage >= 40.0 && percentage <= 60.0;

  /// Check if progress is at the end of the term
  bool get isEnd => percentage > 80.0;

  /// Get progress description
  String get description {
    if (isBeginning) {
      return '🌱 ${currentTerm.name}伊始';
    } else if (isMiddle) {
      return '🌿 ${currentTerm.name}正中';
    } else if (isEnd) {
      return '🍂 ${currentTerm.name}将逝';
    } else {
      return '${currentTerm.name}';
    }
  }

  @override
  String toString() {
    return 'SolarTermProgress('
        'current: ${currentTerm.name}, '
        'next: ${nextTerm.name}, '
        'progress: ${percentage.toStringAsFixed(1)}%, '
        'daysIn: $daysIntoTerm, '
        'daysLeft: $remainingDays'
        ')';
  }
}
