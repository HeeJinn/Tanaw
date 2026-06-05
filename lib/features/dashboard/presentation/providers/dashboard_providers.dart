import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:b_risk/features/dashboard/domain/entities/dashboard_stats.dart';
import 'package:b_risk/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:b_risk/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:b_risk/features/map/presentation/providers/map_providers.dart';

part 'dashboard_providers.g.dart';

@riverpod
DashboardRepository dashboardRepository(Ref ref) {
  return const DashboardRepositoryImpl();
}

@riverpod
DashboardStats dashboardStats(Ref ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  final barangays = ref.watch(barangaysProvider);
  return repository.getStats(barangays);
}
