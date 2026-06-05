class DashboardStats {
  final int totalBarangays;
  final int highRiskCount;
  final int mediumRiskCount;
  final int lowRiskCount;
  final int totalPopulation;
  final double averageTemperature;
  final double overallRiskScore;
  final int populationAtRisk;

  const DashboardStats({
    required this.totalBarangays,
    required this.highRiskCount,
    required this.mediumRiskCount,
    required this.lowRiskCount,
    required this.totalPopulation,
    required this.averageTemperature,
    required this.overallRiskScore,
    required this.populationAtRisk,
  });
}
