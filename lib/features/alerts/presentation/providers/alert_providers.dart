import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:b_risk/features/alerts/domain/entities/alert.dart';
import 'package:b_risk/features/alerts/domain/repositories/alert_repository.dart';
import 'package:b_risk/features/alerts/data/datasources/alert_local_data_source.dart';
import 'package:b_risk/features/alerts/data/repositories/alert_repository_impl.dart';

part 'alert_providers.g.dart';

@riverpod
AlertLocalDataSource alertLocalDataSource(Ref ref) {
  return const AlertLocalDataSourceImpl();
}

@riverpod
AlertRepository alertRepository(Ref ref) {
  final localDataSource = ref.watch(alertLocalDataSourceProvider);
  return AlertRepositoryImpl(localDataSource: localDataSource);
}

@riverpod
class AlertList extends _$AlertList {
  @override
  List<Alert> build() {
    final repository = ref.watch(alertRepositoryProvider);
    return repository.getAlerts();
  }

  void markAsRead(String alertId) {
    state = [
      for (final alert in state)
        if (alert.id == alertId) alert.copyWith(isRead: true) else alert,
    ];
  }

  void markAllAsRead() {
    state = [for (final alert in state) alert.copyWith(isRead: true)];
  }
}

@riverpod
int unreadAlertsCount(Ref ref) {
  final alerts = ref.watch(alertListProvider);
  return alerts.where((a) => !a.isRead).length;
}

@riverpod
class AlertTypeFilter extends _$AlertTypeFilter {
  @override
  String build() {
    return 'All'; // 'All', 'flood', 'earthquake', 'heat'
  }

  void setFilter(String filter) {
    state = filter;
  }
}

@riverpod
List<Alert> filteredAlerts(Ref ref) {
  final alerts = ref.watch(alertListProvider);
  final filter = ref.watch(alertTypeFilterProvider);
  if (filter == 'All') return alerts;
  return alerts.where((a) => a.type == filter).toList();
}
