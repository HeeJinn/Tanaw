import 'package:b_risk/features/map/domain/entities/barangay.dart';
import 'package:b_risk/features/dashboard/domain/entities/dashboard_stats.dart';

abstract class DashboardRepository {
  DashboardStats getStats(List<Barangay> barangays);
}
