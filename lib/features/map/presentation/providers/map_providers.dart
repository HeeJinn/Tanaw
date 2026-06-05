import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:b_risk/features/map/domain/entities/barangay.dart';
import 'package:b_risk/features/map/domain/repositories/barangay_repository.dart';
import 'package:b_risk/features/map/data/datasources/barangay_local_data_source.dart';
import 'package:b_risk/features/map/data/repositories/barangay_repository_impl.dart';

part 'map_providers.g.dart';

@riverpod
BarangayLocalDataSource barangayLocalDataSource(Ref ref) {
  return const BarangayLocalDataSourceImpl();
}

@riverpod
BarangayRepository barangayRepository(Ref ref) {
  final localDataSource = ref.watch(barangayLocalDataSourceProvider);
  return BarangayRepositoryImpl(localDataSource: localDataSource);
}

@riverpod
List<Barangay> barangays(Ref ref) {
  final repository = ref.watch(barangayRepositoryProvider);
  return repository.getBarangays();
}

@riverpod
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
class HoveredBarangay extends _$HoveredBarangay {
  @override
  Barangay? build() {
    return null;
  }

  void hover(Barangay? barangay) {
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
