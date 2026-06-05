import 'package:b_risk/features/alerts/domain/entities/alert.dart';
import 'package:b_risk/features/alerts/domain/repositories/alert_repository.dart';
import 'package:b_risk/features/alerts/data/datasources/alert_local_data_source.dart';

class AlertRepositoryImpl implements AlertRepository {
  final AlertLocalDataSource localDataSource;

  const AlertRepositoryImpl({required this.localDataSource});

  @override
  List<Alert> getAlerts() {
    return localDataSource.getAlerts();
  }
}
