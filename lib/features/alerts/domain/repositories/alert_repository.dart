import 'package:b_risk/features/alerts/domain/entities/alert.dart';

abstract class AlertRepository {
  List<Alert> getAlerts();
}
