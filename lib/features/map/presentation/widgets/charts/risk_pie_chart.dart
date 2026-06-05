import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:b_risk/core/theme/risk_colors.dart';
import 'package:b_risk/features/map/domain/entities/barangay.dart';

class RiskPieChart extends StatefulWidget {
  final List<Barangay> barangays;

  const RiskPieChart({super.key, required this.barangays});

  @override
  State<RiskPieChart> createState() => _RiskPieChartState();
}

class _RiskPieChartState extends State<RiskPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final highCount = widget.barangays.where((b) => b.riskLevel == 'High').length;
    final mediumCount = widget.barangays.where((b) => b.riskLevel == 'Medium').length;
    final lowCount = widget.barangays.where((b) => b.riskLevel == 'Low').length;
    final total = widget.barangays.length;

    return SizedBox(
      height: 200,
      child: Row(
        children: [
          // Donut chart
          Expanded(
            flex: 3,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 3,
                centerSpaceRadius: 36,
                sections: _buildSections(highCount, mediumCount, lowCount),
              ),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
            ),
          ),
          const SizedBox(width: 16),
          // Legend
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$total',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: RiskColors.textPrimaryLight,
                      ),
                ),
                Text(
                  'Total Areas',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: RiskColors.textSecondaryLight,
                      ),
                ),
                const SizedBox(height: 16),
                _buildLegendItem(context, 'High Risk', highCount, RiskColors.high),
                const SizedBox(height: 8),
                _buildLegendItem(context, 'Medium', mediumCount, RiskColors.medium),
                const SizedBox(height: 8),
                _buildLegendItem(context, 'Low Risk', lowCount, RiskColors.low),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(int high, int medium, int low) {
    return [
      _buildSection(0, high.toDouble(), RiskColors.high, 'High'),
      _buildSection(1, medium.toDouble(), RiskColors.medium, 'Medium'),
      _buildSection(2, low.toDouble(), RiskColors.low, 'Low'),
    ];
  }

  PieChartSectionData _buildSection(
      int index, double value, Color color, String title) {
    final isTouched = index == touchedIndex;
    final radius = isTouched ? 32.0 : 24.0;
    final fontSize = isTouched ? 14.0 : 11.0;

    return PieChartSectionData(
      color: color,
      value: value,
      title: isTouched ? '${value.toInt()}' : '',
      radius: radius,
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      badgePositionPercentageOffset: 1.8,
      badgeWidget: isTouched
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '$title: ${value.toInt()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildLegendItem(
      BuildContext context, String label, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: RiskColors.textSecondaryLight,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        Text(
          '$count',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: RiskColors.textPrimaryLight,
              ),
        ),
      ],
    );
  }
}
