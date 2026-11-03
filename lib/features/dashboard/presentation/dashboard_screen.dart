import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_new_shapes/material_new_shapes.dart';
import 'package:b_risk/core/theme/risk_colors.dart';
import 'package:b_risk/core/widgets/expressive.dart';
import 'package:b_risk/features/auth/presentation/widgets/account_button.dart';
import 'package:b_risk/features/dashboard/domain/entities/dashboard_stats.dart';
import 'package:b_risk/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:b_risk/features/dashboard/presentation/widgets/stat_card.dart';
import 'package:b_risk/features/dashboard/presentation/widgets/high_risk_areas_list.dart';
import 'package:b_risk/features/map/presentation/providers/map_providers.dart';
import 'package:b_risk/features/map/presentation/widgets/charts/risk_pie_chart.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(dashboardStatsProvider);
    final barangays = ref.watch(barangaysProvider).value ?? const [];
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text('Tanaw'),
            actions: [AccountButton(), SizedBox(width: 8)],
          ),
          ...stats.when(
            loading: () => [const SliverFillRemaining(hasScrollBody: false, child: LoadingState())],
            error: (error, _) => [
              SliverFillRemaining(
                hasScrollBody: false,
                child: ErrorState(
                  message: "Couldn't load risk data. Check your connection.",
                  onRetry: () => ref.invalidate(barangaysProvider),
                ),
              ),
            ],
            data: (stats) => [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList.list(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 16),
                      child: Text(
                        'Binalonan, Pangasinan · risk overview',
                        style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ),
                    _RiskHeroCard(stats: stats),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        StatCard(
                          label: 'High-risk areas',
                          value: '${stats.highRiskCount}',
                          icon: Icons.warning_amber_rounded,
                          shape: MaterialShapes.softBurst,
                          color: RiskColors.high,
                        ),
                        const SizedBox(width: 12),
                        StatCard(
                          label: 'People at risk',
                          value: _formatPopulation(stats.populationAtRisk),
                          icon: Icons.people_alt_rounded,
                          shape: MaterialShapes.clover4Leaf,
                          color: RiskColors.heat,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        StatCard(
                          label: 'Barangays',
                          value: '${stats.totalBarangays}',
                          icon: Icons.location_city_rounded,
                          shape: MaterialShapes.cookie6Sided,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        StatCard(
                          label: 'Avg temperature',
                          value: '${stats.averageTemperature}°',
                          icon: Icons.device_thermostat_rounded,
                          shape: MaterialShapes.sunny,
                          color: RiskColors.medium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Card.filled(
                      color: theme.colorScheme.surfaceContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Risk distribution', style: theme.textTheme.titleLarge),
                            const SizedBox(height: 8),
                            RiskPieChart(barangays: barangays),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    HighRiskAreasList(barangays: barangays),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPopulation(int pop) {
    if (pop >= 1000) {
      return '${(pop / 1000).toStringAsFixed(1)}K';
    }
    return '$pop';
  }
}

class _RiskHeroCard extends StatelessWidget {
  final DashboardStats stats;

  const _RiskHeroCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onColor = theme.colorScheme.onPrimaryContainer;
    return Card.filled(
      color: theme.colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Overall risk score', style: theme.textTheme.titleMedium?.copyWith(color: onColor)),
                      Text(
                        '${stats.overallRiskScore.toStringAsFixed(0)}%',
                        style: theme.textTheme.displayMedium?.copyWith(color: onColor),
                      ),
                    ],
                  ),
                ),
                ShapeIcon(
                  icon: Icons.shield_rounded,
                  shape: MaterialShapes.cookie9Sided,
                  color: onColor,
                  size: 64,
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: stats.overallRiskScore / 100,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
              color: onColor,
              backgroundColor: onColor.withValues(alpha: 0.15),
              // ignore: deprecated_member_use
              year2023: false,
            ),
            const SizedBox(height: 12),
            Text(
              'Average of flood and heat risk across ${stats.totalBarangays} barangays',
              style: theme.textTheme.bodyMedium?.copyWith(color: onColor.withValues(alpha: 0.8)),
            ),
          ],
        ),
      ),
    );
  }
}
