import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:b_risk/features/auth/presentation/providers/auth_providers.dart';
import 'package:b_risk/features/map/domain/entities/barangay.dart';
import 'package:b_risk/features/map/domain/repositories/barangay_repository.dart';
import 'package:b_risk/features/map/data/datasources/barangay_remote_data_source.dart';
import 'package:b_risk/features/map/data/repositories/barangay_repository_impl.dart';

part 'map_providers.g.dart';

@riverpod
BarangayRemoteDataSource barangayRemoteDataSource(Ref ref) {
  return BarangayRemoteDataSourceImpl(firestore: FirebaseFirestore.instance);
}

@riverpod
BarangayRepository barangayRepository(Ref ref) {
  final remoteDataSource = ref.watch(barangayRemoteDataSourceProvider);
  return BarangayRepositoryImpl(remoteDataSource: remoteDataSource);
}

@riverpod
Stream<List<Barangay>> barangays(Ref ref) {
  // Firestore only lets signed-in users read
  if (ref.watch(authUidProvider) == null) return const Stream.empty();
  final repository = ref.watch(barangayRepositoryProvider);
  return repository.watchBarangays();
}

// keepAlive: the dashboard selects a barangay before the map tab is mounted to watch it.
@Riverpod(keepAlive: true)
class SelectedBarangay extends _$SelectedBarangay {
  @override
  Barangay? build() {
    return null;
  }

  void select(Barangay? barangay) {
    state = barangay;
  }
}

@riverpod
class RiskFilter extends _$RiskFilter {
  @override
  String build() {
    return 'All'; // Can be 'All', 'High', 'Medium', 'Low'
  }

  void setFilter(String filter) {
    state = filter;
  }
}

@riverpod
AsyncValue<List<Barangay>> filteredBarangays(Ref ref) {
  final filter = ref.watch(riskFilterProvider);
  return ref.watch(barangaysProvider).whenData((barangays) => filter == 'All'
      ? barangays
      : barangays.where((b) => b.riskLevel == filter).toList());
}
