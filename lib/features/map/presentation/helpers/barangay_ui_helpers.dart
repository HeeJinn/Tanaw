import 'package:flutter/material.dart';
import 'package:material_new_shapes/material_new_shapes.dart';
import 'package:b_risk/features/map/domain/entities/barangay.dart';
import 'package:b_risk/core/theme/risk_colors.dart';

extension BarangayUI on Barangay {
  Color get riskColor => RiskColors.colorForRisk(riskLevel);

  IconData get riskIcon => RiskColors.iconForRisk(riskLevel);

  RoundedPolygon get riskShape => RiskColors.shapeForRisk(riskLevel);

  /// Formatted population string.
  String get populationFormatted {
    if (population >= 1000) {
      return '${(population / 1000).toStringAsFixed(1)}K';
    }
    return '$population';
  }

  /// Average risk score across all risk types.
  double get averageRisk => (floodRisk + heatRisk) / 2;
}
