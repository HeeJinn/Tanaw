import 'package:b_risk/features/alerts/domain/entities/alert.dart';

abstract class AlertRepository {
  Stream<List<Alert>> watchAlerts();
  Future<Set<String>> getReadIds();
  Future<void> saveReadIds(Set<String> ids);
}
