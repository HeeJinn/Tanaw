import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:b_risk/core/theme/risk_colors.dart';
import 'package:b_risk/features/map/domain/entities/barangay.dart';

class TemperatureLineChart extends StatelessWidget {
  final Barangay barangay;

  const TemperatureLineChart({super.key, required this.barangay});

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
  static const double _dangerThreshold = 33.0;

  @override
  Widget build(BuildContext context) {
    final temps = barangay.historicalTemperatures;
    final minTemp = temps.reduce((a, b) => a < b ? a : b) - 1.5;
    final maxTemp = temps.reduce((a, b) => a > b ? a : b) + 1.5;

    return SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, right: 16),
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (_) => RiskColors.surfaceDarkMid,
                tooltipRoundedRadius: 8,
                tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    return LineTooltipItem(
                      '${_months[spot.x.toInt()]}\n',
                      const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                      children: [
                        TextSpan(
                          text: '${spot.y.toStringAsFixed(1)}°C',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  }).toList();
                },
              ),
              handleBuiltInTouches: true,
              getTouchedSpotIndicator: (barData, spotIndexes) {
                return spotIndexes.map((index) {
                  return TouchedSpotIndicatorData(
                    FlLine(
                      color: RiskColors.chartLine.withValues(alpha: 0.4),
                      strokeWidth: 1.5,
                      dashArray: [4, 4],
                    ),
                    FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 6,
                          color: Colors.white,
                          strokeWidth: 2.5,
                          strokeColor: RiskColors.chartLine,
                        );
                      },
                    ),
                  );
                }).toList();
              },
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: RiskColors.chartGrid,
                  strokeWidth: 0.8,
                  dashArray: [4, 4],
                );
              },
            ),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 24,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= _months.length) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        _months[index],
                        style: TextStyle(
                          color: RiskColors.textTertiaryLight,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 36,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    if (value == meta.max || value == meta.min) {
                      return const SizedBox.shrink();
                    }
                    return Text(
                      '${value.toInt()}°',
                      style: TextStyle(
                        color: RiskColors.textTertiaryLight,
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: (temps.length - 1).toDouble(),
            minY: minTemp,
            maxY: maxTemp,
            extraLinesData: ExtraLinesData(
              horizontalLines: [
                HorizontalLine(
                  y: _dangerThreshold,
                  color: RiskColors.high.withValues(alpha: 0.5),
                  strokeWidth: 1.5,
                  dashArray: [6, 4],
                  label: HorizontalLineLabel(
                    show: true,
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.only(right: 4, bottom: 2),
                    style: TextStyle(
                      color: RiskColors.high.withValues(alpha: 0.7),
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                    labelResolver: (_) => '${_dangerThreshold.toInt()}° Danger',
                  ),
                ),
              ],
            ),
            lineBarsData: [
              LineChartBarData(
                spots: temps.asMap().entries.map((e) {
                  return FlSpot(e.key.toDouble(), e.value);
                }).toList(),
                isCurved: true,
                curveSmoothness: 0.3,
                color: RiskColors.chartLine,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 3.5,
                      color: Colors.white,
                      strokeWidth: 2,
                      strokeColor: RiskColors.chartLine,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      RiskColors.chartLine.withValues(alpha: 0.25),
                      RiskColors.chartLine.withValues(alpha: 0.02),
                    ],
                  ),
                ),
              ),
            ],
          ),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
        ),
      ),
    );
  }
}
