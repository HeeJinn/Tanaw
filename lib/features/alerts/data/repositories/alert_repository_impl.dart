import 'package:b_risk/features/alerts/domain/entities/alert.dart';
import 'package:b_risk/features/alerts/domain/repositories/alert_repository.dart';
import 'package:b_risk/features/alerts/data/datasources/alert_local_data_source.dart';
import 'package:b_risk/features/alerts/data/datasources/alert_remote_data_source.dart';

class AlertRepositoryImpl implements AlertRepository {
  final AlertRemoteDataSource remoteDataSource;
  final AlertLocalDataSource localDataSource;

  const AlertRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Stream<List<Alert>> watchAlerts() => remoteDataSource.watchAlerts();

  @override
  Future<Set<String>> getReadIds() => localDataSource.getReadIds();

  @override
  Future<void> saveReadIds(Set<String> ids) => localDataSource.saveReadIds(ids);
}
