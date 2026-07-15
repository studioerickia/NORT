import 'package:flutter/material.dart' show DateTimeRange;

enum SummaryPeriod { today, thisWeek, thisMonth, thisYear, custom }

class PeriodSelection {
  const PeriodSelection.preset(this.type)
      : customStart = null,
        customEnd = null;

  const PeriodSelection.custom({required DateTime start, required DateTime end})
      : type = SummaryPeriod.custom,
        customStart = start,
        customEnd = end;

  final SummaryPeriod type;
  final DateTime? customStart;
  final DateTime? customEnd;

  static const today = PeriodSelection.preset(SummaryPeriod.today);
  static const thisWeek = PeriodSelection.preset(SummaryPeriod.thisWeek);
  static const thisMonth = PeriodSelection.preset(SummaryPeriod.thisMonth);
  static const thisYear = PeriodSelection.preset(SummaryPeriod.thisYear);

  DateTimeRange range({DateTime? now}) {
    final reference = now ?? DateTime.now();

    switch (type) {
      case SummaryPeriod.today:
        final start = DateTime(reference.year, reference.month, reference.day);
        return DateTimeRange(
            start: start, end: start.add(const Duration(days: 1)));

      case SummaryPeriod.thisWeek:
        final startOfToday =
            DateTime(reference.year, reference.month, reference.day);
        final start =
            startOfToday.subtract(Duration(days: reference.weekday - 1));
        return DateTimeRange(
            start: start, end: start.add(const Duration(days: 7)));

      case SummaryPeriod.thisMonth:
        final start = DateTime(reference.year, reference.month, 1);
        final end = DateTime(reference.year, reference.month + 1, 1);
        return DateTimeRange(start: start, end: end);

      case SummaryPeriod.thisYear:
        final start = DateTime(reference.year, 1, 1);
        final end = DateTime(reference.year + 1, 1, 1);
        return DateTimeRange(start: start, end: end);

      case SummaryPeriod.custom:
        return DateTimeRange(
          start: customStart!,
          end: customEnd!.add(const Duration(days: 1)),
        );
    }
  }

  bool contains(DateTime date, {DateTime? now}) {
    final r = range(now: now);
    return !date.isBefore(r.start) && date.isBefore(r.end);
  }

  String get label {
    switch (type) {
      case SummaryPeriod.today:
        return 'Hoje';
      case SummaryPeriod.thisWeek:
        return 'Esta semana';
      case SummaryPeriod.thisMonth:
        return 'Este mês';
      case SummaryPeriod.thisYear:
        return 'Este ano';
      case SummaryPeriod.custom:
        return 'Período personalizado';
    }
  }
}
