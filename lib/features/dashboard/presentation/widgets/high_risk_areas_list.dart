import 'package:flutter/material.dart';
import 'package:b_risk/features/map/domain/entities/barangay.dart';
import 'package:b_risk/features/map/presentation/helpers/barangay_ui_helpers.dart';
import 'package:b_risk/core/theme/risk_colors.dart';

class HighRiskAreasList extends StatelessWidget {
  final List<Barangay> barangays;

  const HighRiskAreasList({super.key, required this.barangays});

  @override
  Widget build(BuildContext context) {
    final highRiskAreas = barangays
        .where((b) => b.riskLevel == 'High')
        .toList()
      ..sort((a, b) => b.averageRisk.compareTo(a.averageRisk));

    if (highRiskAreas.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded, size: 16, color: RiskColors.high),
              const SizedBox(width: 8),
              Text(
                'High-Risk Areas',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: RiskColors.textPrimaryLight,
                    ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: RiskColors.highSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${highRiskAreas.length} areas',
                  style: TextStyle(
                    color: RiskColors.high,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: highRiskAreas.length,
            separatorBuilder: (context, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final area = highRiskAreas[index];
              return _HighRiskCard(barangay: area);
            },
          ),
        ),
      ],
    );
  }
}

class _HighRiskCard extends StatelessWidget {
  final Barangay barangay;

  const _HighRiskCard({required this.barangay});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            RiskColors.high.withValues(alpha: 0.08),
            RiskColors.high.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: RiskColors.high.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: RiskColors.high.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  size: 14,
                  color: RiskColors.high,
                ),
              ),
              const Spacer(),
              Text(
                '${(barangay.averageRisk * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: RiskColors.high,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            barangay.name,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: RiskColors.textPrimaryLight,
              letterSpacing: -0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.device_thermostat_rounded,
                  size: 12, color: RiskColors.chartHeat),
              const SizedBox(width: 2),
              Text(
                '${barangay.temperature}°C',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: RiskColors.textSecondaryLight,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.people_alt_outlined,
                  size: 12, color: RiskColors.textTertiaryLight),
              const SizedBox(width: 2),
              Text(
                barangay.populationFormatted,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: RiskColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
