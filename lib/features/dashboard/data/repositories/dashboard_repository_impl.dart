import 'package:b_risk/features/map/domain/entities/barangay.dart';
import 'package:b_risk/features/dashboard/domain/entities/dashboard_stats.dart';
import 'package:b_risk/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl();

  @override
  DashboardStats getStats(List<Barangay> barangays) {
    final highRisk = barangays.where((b) => b.riskLevel == 'High').toList();
    final mediumRisk = barangays.where((b) => b.riskLevel == 'Medium').toList();
    final lowRisk = barangays.where((b) => b.riskLevel == 'Low').toList();

    final totalPopulation =
        barangays.fold<int>(0, (sum, b) => sum + b.population);
    final avgTemp = barangays.isEmpty
        ? 0.0
        : barangays.fold<double>(0.0, (sum, b) => sum + b.temperature) /
            barangays.length;

    // Population at risk = population in High + Medium risk zones
    final populationAtRisk =
        [...highRisk, ...mediumRisk].fold<int>(0, (sum, b) => sum + b.population);

    // Overall risk score: weighted average of all risk factors across all barangays
    final overallRisk = barangays.isEmpty
        ? 0.0
        : barangays.fold<double>(
                0.0,
                (sum, b) =>
                    sum +
                    (b.floodRisk + b.earthquakeRisk + b.heatRisk) / 3) /
            barangays.length;

    return DashboardStats(
      totalBarangays: barangays.length,
      highRiskCount: highRisk.length,
      mediumRiskCount: mediumRisk.length,
      lowRiskCount: lowRisk.length,
      totalPopulation: totalPopulation,
      averageTemperature: double.parse(avgTemp.toStringAsFixed(1)),
      overallRiskScore: double.parse((overallRisk * 100).toStringAsFixed(1)),
      populationAtRisk: populationAtRisk,
    );
  }
}
