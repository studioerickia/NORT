import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/period.dart';

final selectedSummaryPeriodProvider = StateProvider<PeriodSelection>((ref) {
  return PeriodSelection.thisMonth;
});