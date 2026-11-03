import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:b_risk/core/theme/risk_colors.dart';
import 'package:b_risk/features/map/domain/entities/barangay.dart';

class RiskBarChart extends StatelessWidget {
  final Barangay barangay;

  const RiskBarChart({super.key, required this.barangay});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 180,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, right: 16),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 1.0,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => scheme.inverseSurface,
                tooltipBorderRadius: BorderRadius.circular(8),
                tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final labels = ['Flood', 'Heat'];
                  final value = rod.toY;
                  return BarTooltipItem(
                    '${labels[group.x]}\n',
                    TextStyle(
                      color: scheme.onInverseSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                    children: [
                      TextSpan(
                        text: '${(value * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          color: scheme.onInverseSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  getTitlesWidget: (value, meta) {
                    final type = const ['flood', 'heat'][value.toInt()];
                    final icon = RiskColors.iconForHazard(type);
                    final label = type == 'flood' ? 'Flood' : 'Heat';
                    final color = RiskColors.colorForHazard(type);
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, size: 12, color: color),
                          const SizedBox(width: 3),
                          Text(
                            label,
                            style: TextStyle(
                              color: scheme.onSurfaceVariant,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  interval: 0.25,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${(value * 100).toInt()}%',
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 0.25,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: scheme.outlineVariant,
                  strokeWidth: 1,
                  dashArray: [4, 4],
                );
              },
            ),
            borderData: FlBorderData(show: false),
            barGroups: [
              _buildBarGroup(0, barangay.floodRisk, RiskColors.flood),
              _buildBarGroup(1, barangay.heatRisk, RiskColors.heat),
            ],
          ),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double value, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          width: 28,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              color.withValues(alpha: 0.6),
              color,
            ],
          ),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 1.0,
            color: color.withValues(alpha: 0.06),
          ),
        ),
      ],
    );
  }
}
