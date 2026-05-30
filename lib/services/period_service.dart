import '../models/period_model.dart';

class PeriodService {

  PeriodModel getPeriodData() {
    return PeriodModel(
      nextPeriodDays: 8,
      cycleDay: 20,
      cycleLength: 28,
    );
  }
}