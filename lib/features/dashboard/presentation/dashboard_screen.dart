import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:b_risk/core/theme/risk_colors.dart';
import 'package:b_risk/features/map/presentation/providers/map_providers.dart';
import 'package:b_risk/features/map/presentation/widgets/charts/risk_pie_chart.dart';
import 'package:b_risk/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:b_risk/features/dashboard/presentation/widgets/stat_card.dart';
import 'package:b_risk/features/dashboard/presentation/widgets/quick_action_card.dart';
import 'package:b_risk/features/dashboard/presentation/widgets/high_risk_areas_list.dart';
import 'package:b_risk/features/alerts/presentation/providers/alert_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(dashboardStatsProvider);
    final barangays = ref.watch(barangaysProvider);
    final unreadCount = ref.watch(unreadAlertsCountProvider);

    return Scaffold(
      backgroundColor: RiskColors.surfaceLight,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white.withValues(alpha: 0.95),
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'B-Risk Dashboard',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: RiskColors.textPrimaryLight,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Binalonan Risk Assessment',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: RiskColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [RiskColors.primary, RiskColors.primaryDark],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: RiskColors.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shield_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          // ── Stats Grid ──────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            sliver: SliverToBoxAdapter(
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  StatCard(
                    label: 'TOTAL',
                    value: '${stats.totalBarangays}',
                    subtitle: 'Barangays monitored',
                    icon: Icons.location_city_rounded,
                    color: RiskColors.primary,
                  ),
                  StatCard(
                    label: 'HIGH RISK',
                    value: '${stats.highRiskCount}',
                    subtitle: 'Areas need attention',
                    icon: Icons.warning_amber_rounded,
                    color: RiskColors.high,
                  ),
                  StatCard(
                    label: 'POPULATION',
                    value: _formatPopulation(stats.populationAtRisk),
                    subtitle: 'At risk population',
                    icon: Icons.people_alt_rounded,
                    color: RiskColors.chartHeat,
                  ),
                  StatCard(
                    label: 'AVG TEMP',
                    value: '${stats.averageTemperature}°',
                    subtitle: 'Average temperature',
                    icon: Icons.device_thermostat_rounded,
                    color: RiskColors.medium,
                  ),
                ],
              ),
            ),
          ),

          // ── Risk Distribution Chart ──────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: RiskColors.borderLight, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.pie_chart_rounded,
                            size: 16, color: RiskColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Risk Distribution',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: RiskColors.textPrimaryLight,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    RiskPieChart(barangays: barangays),
                  ],
                ),
              ),
            ),
          ),

          // ── High Risk Areas ──────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.only(top: 24),
            sliver: SliverToBoxAdapter(
              child: HighRiskAreasList(barangays: barangays),
            ),
          ),

          // ── Quick Actions ──────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.bolt_rounded,
                          size: 16, color: RiskColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Quick Actions',
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: RiskColors.textPrimaryLight,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  QuickActionCard(
                    label: 'View Risk Map',
                    subtitle: 'Explore interactive barangay map',
                    icon: Icons.map_rounded,
                    color: RiskColors.primary,
                    onTap: () {
                      final shell = StatefulNavigationShell.of(context);
                      shell.goBranch(1);
                    },
                  ),
                  const SizedBox(height: 10),
                  QuickActionCard(
                    label: 'View Alerts',
                    subtitle: unreadCount > 0
                        ? '$unreadCount unread alert${unreadCount > 1 ? 's' : ''}'
                        : 'All caught up',
                    icon: Icons.notifications_rounded,
                    color: unreadCount > 0 ? RiskColors.high : RiskColors.low,
                    onTap: () {
                      final shell = StatefulNavigationShell.of(context);
                      shell.goBranch(2);
                    },
                  ),
                ],
              ),
            ),
          ),

          // ── Overall Risk Score ──────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [RiskColors.primary, RiskColors.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: RiskColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Overall Risk Score',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${stats.overallRiskScore}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Across ${stats.totalBarangays} monitored barangays',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.shield_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
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
