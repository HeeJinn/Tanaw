import 'package:flutter/material.dart';
import 'package:b_risk/features/map/domain/entities/barangay.dart';
import 'package:b_risk/core/theme/risk_colors.dart';

extension BarangayUI on Barangay {
  /// Returns the curated risk color from the design system.
  Color get riskColor => RiskColors.colorForRisk(riskLevel);

  /// Returns a surface-tinted background color for cards.
  Color get riskSurfaceColor => RiskColors.surfaceForRisk(riskLevel);

  /// Returns an appropriate icon for the risk level.
  IconData get riskIcon => RiskColors.iconForRisk(riskLevel);

  /// Returns a gradient for the risk level.
  LinearGradient get riskGradient => RiskColors.gradientForRisk(riskLevel);

  /// Formatted population string.
  String get populationFormatted {
    if (population >= 1000) {
      return '${(population / 1000).toStringAsFixed(1)}K';
    }
    return '$population';
  }

  /// Average risk score across all risk types.
  double get averageRisk => (floodRisk + earthquakeRisk + heatRisk) / 3;
}
