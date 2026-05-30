import '../models/period_model.dart';
import '../services/period_service.dart';

class PeriodRepository {

  final PeriodService _service =
  PeriodService();

  PeriodModel getPeriod() {

    return _service.getPeriodData();

  }
}