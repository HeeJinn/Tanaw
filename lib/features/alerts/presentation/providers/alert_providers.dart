import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:b_risk/features/auth/presentation/providers/auth_providers.dart';
import 'package:b_risk/features/alerts/domain/entities/alert.dart';
import 'package:b_risk/features/alerts/domain/repositories/alert_repository.dart';
import 'package:b_risk/features/alerts/data/datasources/alert_local_data_source.dart';
import 'package:b_risk/features/alerts/data/datasources/alert_remote_data_source.dart';
import 'package:b_risk/features/alerts/data/repositories/alert_repository_impl.dart';

part 'alert_providers.g.dart';

@riverpod
AlertRepository alertRepository(Ref ref) {
  return AlertRepositoryImpl(
    remoteDataSource:
        AlertRemoteDataSourceImpl(firestore: FirebaseFirestore.instance),
    localDataSource: const AlertLocalDataSourceImpl(),
  );
}

@riverpod
Stream<List<Alert>> alerts(Ref ref) {
  if (ref.watch(authUidProvider) == null) return const Stream.empty();
  return ref.watch(alertRepositoryProvider).watchAlerts();
}

@riverpod
class ReadAlertIds extends _$ReadAlertIds {
  @override
  Future<Set<String>> build() {
    return ref.watch(alertRepositoryProvider).getReadIds();
  }

  Future<void> markAsRead(Iterable<String> ids) async {
    final next = {...?state.value, ...ids};
    state = AsyncData(next);
    await ref.read(alertRepositoryProvider).saveReadIds(next);
  }
}

/// Alerts from the server, flagged with this device's read state.
@riverpod
AsyncValue<List<Alert>> alertList(Ref ref) {
  final readIds = ref.watch(readAlertIdsProvider).value ?? const <String>{};
  return ref.watch(alertsProvider).whenData((alerts) => [
        for (final alert in alerts)
          alert.copyWith(isRead: readIds.contains(alert.id)),
      ]);
}

@riverpod
int unreadAlertsCount(Ref ref) {
  final alerts = ref.watch(alertListProvider).value ?? const [];
  return alerts.where((a) => !a.isRead).length;
}

@riverpod
class AlertTypeFilter extends _$AlertTypeFilter {
  @override
  String build() {
    return 'All'; // 'All', 'flood', 'heat'
  }

  void setFilter(String filter) {
    state = filter;
  }
}

@riverpod
AsyncValue<List<Alert>> filteredAlerts(Ref ref) {
  final filter = ref.watch(alertTypeFilterProvider);
  return ref.watch(alertListProvider).whenData((alerts) => filter == 'All'
      ? alerts
      : alerts.where((a) => a.type == filter).toList());
}
