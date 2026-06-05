import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:b_risk/features/map/domain/entities/barangay.dart';
import 'package:b_risk/features/map/presentation/providers/map_providers.dart';
import 'package:b_risk/features/map/presentation/helpers/barangay_ui_helpers.dart';
import 'package:b_risk/features/map/presentation/widgets/charts/risk_pie_chart.dart';
import 'package:b_risk/features/map/presentation/widgets/charts/risk_bar_chart.dart';
import 'package:b_risk/features/map/presentation/widgets/charts/temperature_line_chart.dart';
import 'package:b_risk/core/theme/risk_colors.dart';

class BarangayBottomSheet extends ConsumerStatefulWidget {
  final MapController mapController;

  const BarangayBottomSheet({
    super.key,
    required this.mapController,
  });

  @override
  ConsumerState<BarangayBottomSheet> createState() => _BarangayBottomSheetState();
}

class _BarangayBottomSheetState extends ConsumerState<BarangayBottomSheet> {
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  ScrollController? _innerScrollController;

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  void _selectAndFlyTo(Barangay barangay) {
    ref.read(selectedBarangayProvider.notifier).select(barangay);
    widget.mapController.move(barangay.coordinates, 15.5);
    
    // Animate the sheet down
    _sheetController.animateTo(
      0.15,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
    
    // Scroll back to the top so the drag handle is visible
    if (_innerScrollController != null && _innerScrollController!.hasClients) {
      _innerScrollController!.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final barangays = ref.watch(barangaysProvider);
    final selectedBarangay = ref.watch(selectedBarangayProvider);
    final selectedFilter = ref.watch(riskFilterProvider);

    final filteredBarangays = barangays.where((b) {
      if (selectedFilter == 'All') return true;
      return b.riskLevel == selectedFilter;
    }).toList();

    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.15,
      minChildSize: 0.15,
      maxChildSize: 1.0,
      expand: true,
      snap: true,
      snapSizes: const [0.5],
      builder: (BuildContext context, ScrollController scrollController) {
        _innerScrollController = scrollController;
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 30,
                    offset: const Offset(0, -8),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  // ── 1. Drag Handle + Header ──────────────────────────
                  SliverToBoxAdapter(
                    child: _buildHeader(context, selectedBarangay, filteredBarangays.length),
                  ),

                  // ── 2. Filter Chips ──────────────────────────────────
                  SliverToBoxAdapter(
                    child: _buildFilterChips(ref, selectedFilter),
                  ),

                  // ── 3. Overview Stats + Pie Chart ────────────────────
                  if (selectedBarangay == null)
                    SliverToBoxAdapter(
                      child: _buildDashboardOverview(context, barangays),
                    ),

                  // ── 4. Selected Barangay Detail ──────────────────────
                  if (selectedBarangay != null)
                    SliverToBoxAdapter(
                      child: _buildSelectedDetail(context, ref, selectedBarangay),
                    ),

                  // ── 5. Section Label ─────────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
                      child: Row(
                        children: [
                          Text(
                            selectedBarangay != null
                                ? 'Other Areas'
                                : 'All Barangays',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: RiskColors.textPrimaryLight,
                                  letterSpacing: -0.2,
                                ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: RiskColors.primarySurface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${filteredBarangays.length} areas',
                              style: TextStyle(
                                color: RiskColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── 6. Barangay List ─────────────────────────────────
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final barangay = filteredBarangays[index];
                          if (barangay.name == selectedBarangay?.name) {
                            return const SizedBox.shrink();
                          }
                          return _buildBarangayCard(context, ref, barangay, isSelected: false);
                        },
                        childCount: filteredBarangays.length,
                      ),
                    ),
                  ),

                  // ── 7. Emergency Guidelines ──────────────────────────
                  SliverToBoxAdapter(
                    child: _buildPreparednessSection(context),
                  ),

                  // Bottom safe-area padding
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 32),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // HEADER
  // ════════════════════════════════════════════════════════════════════
  Widget _buildHeader(BuildContext context, Barangay? selected, int count) {
    return Column(
      children: [
        const SizedBox(height: 12),
        // Drag handle
        Container(
          height: 4,
          width: 36,
          decoration: BoxDecoration(
            color: RiskColors.textTertiaryLight.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              // App icon
              Container(
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selected == null ? 'B-Risk Dashboard' : selected.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: RiskColors.textPrimaryLight,
                            letterSpacing: -0.3,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      selected == null
                          ? 'Binalonan Risk Assessment'
                          : '${selected.riskLevel} Risk Zone • ${selected.temperature}°C',
                      style: TextStyle(
                        color: selected != null
                            ? selected.riskColor
                            : RiskColors.textSecondaryLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Divider(
            height: 1,
            color: RiskColors.borderLight.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // FILTER CHIPS
  // ════════════════════════════════════════════════════════════════════
  Widget _buildFilterChips(WidgetRef ref, String currentFilter) {
    final filters = ['All', 'High', 'Medium', 'Low'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: filters.map((filter) {
          final isSelected = currentFilter == filter;
          final color = RiskColors.colorForRisk(filter);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => ref.read(riskFilterProvider.notifier).setFilter(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? color : color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected ? color : color.withValues(alpha: 0.2),
                    width: 1.2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (filter != 'All') ...[
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.white : color,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // DASHBOARD OVERVIEW (Pie Chart + Stats)
  // ════════════════════════════════════════════════════════════════════
  Widget _buildDashboardOverview(BuildContext context, List<Barangay> barangays) {
    final highCount = barangays.where((b) => b.riskLevel == 'High').length;
    final mediumCount = barangays.where((b) => b.riskLevel == 'Medium').length;
    final lowCount = barangays.where((b) => b.riskLevel == 'Low').length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stat cards row
          Row(
            children: [
              Expanded(child: _buildGlassStatCard('High', highCount, RiskColors.high, Icons.warning_amber_rounded)),
              const SizedBox(width: 8),
              Expanded(child: _buildGlassStatCard('Medium', mediumCount, RiskColors.medium, Icons.shield_outlined)),
              const SizedBox(width: 8),
              Expanded(child: _buildGlassStatCard('Low', lowCount, RiskColors.low, Icons.verified_user_outlined)),
            ],
          ),
          const SizedBox(height: 16),
          // Pie chart card
          Container(
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
                    Icon(Icons.pie_chart_rounded, size: 16, color: RiskColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Risk Distribution',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildGlassStatCard(String label, int count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.08),
            color.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'areas',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // SELECTED BARANGAY DETAIL (Charts)
  // ════════════════════════════════════════════════════════════════════
  Widget _buildSelectedDetail(BuildContext context, WidgetRef ref, Barangay barangay) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick stats row
          Row(
            children: [
              Expanded(child: _buildDetailStat(
                context, Icons.people_alt_rounded, 'Population',
                barangay.populationFormatted, RiskColors.primary,
              )),
              const SizedBox(width: 8),
              Expanded(child: _buildDetailStat(
                context, Icons.device_thermostat_rounded, 'Temperature',
                '${barangay.temperature}°C', RiskColors.chartHeat,
              )),
              const SizedBox(width: 8),
              Expanded(child: _buildDetailStat(
                context, Icons.speed_rounded, 'Avg Risk',
                '${(barangay.averageRisk * 100).toStringAsFixed(0)}%', barangay.riskColor,
              )),
            ],
          ),
          const SizedBox(height: 12),

          // Risk breakdown bar chart
          _buildChartCard(
            context,
            icon: Icons.bar_chart_rounded,
            title: 'Risk Breakdown',
            subtitle: 'Flood, earthquake & heat analysis',
            child: RiskBarChart(barangay: barangay),
          ),
          const SizedBox(height: 12),

          // Temperature line chart
          _buildChartCard(
            context,
            icon: Icons.show_chart_rounded,
            title: 'Temperature Trend',
            subtitle: '6-month historical data',
            child: TemperatureLineChart(barangay: barangay),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildDetailStat(
    BuildContext context, IconData icon, String label, String value, Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.12), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: RiskColors.textTertiaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
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
              Icon(icon, size: 16, color: RiskColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: RiskColors.textPrimaryLight,
                          ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: RiskColors.textTertiaryLight,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // BARANGAY LIST CARD
  // ════════════════════════════════════════════════════════════════════
  Widget _buildBarangayCard(BuildContext context, WidgetRef ref, Barangay barangay, {required bool isSelected}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _selectAndFlyTo(barangay),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isSelected
                  ? RiskColors.primarySurface.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? RiskColors.primary.withValues(alpha: 0.3)
                    : RiskColors.borderLight.withValues(alpha: 0.6),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Risk indicator bar
                Container(
                  width: 4,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: barangay.riskGradient,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                const SizedBox(width: 12),
                // Icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: barangay.riskSurfaceColor.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    barangay.riskIcon,
                    color: barangay.riskColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        barangay.name,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isSelected ? RiskColors.primary : RiskColors.textPrimaryLight,
                          fontSize: 14,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: barangay.riskColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              barangay.riskLevel,
                              style: TextStyle(
                                color: barangay.riskColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.device_thermostat_rounded, size: 12, color: RiskColors.chartHeat),
                          Text(
                            '${barangay.temperature}°C',
                            style: TextStyle(
                              fontSize: 11,
                              color: RiskColors.textSecondaryLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.people_alt_outlined, size: 12, color: RiskColors.textTertiaryLight),
                          const SizedBox(width: 2),
                          Text(
                            barangay.populationFormatted,
                            style: TextStyle(
                              fontSize: 11,
                              color: RiskColors.textSecondaryLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Chevron
                Icon(
                  isSelected ? Icons.gps_fixed_rounded : Icons.chevron_right_rounded,
                  color: isSelected ? RiskColors.primary : RiskColors.textTertiaryLight,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // PREPAREDNESS SECTION
  // ════════════════════════════════════════════════════════════════════
  Widget _buildPreparednessSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Divider(color: RiskColors.borderLight.withValues(alpha: 0.6)),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: RiskColors.high.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.health_and_safety_rounded, size: 16, color: RiskColors.high),
              ),
              const SizedBox(width: 10),
              Text(
                'Emergency & Safety Guidelines',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: RiskColors.textPrimaryLight,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSafetyCard(
            title: 'Flood Alert Protocol',
            subtitle: 'Pack essential supplies and move to designated evacuation centers in Poblacion and Bued.',
            icon: Icons.waves_rounded,
            color: RiskColors.chartFlood,
          ),
          const SizedBox(height: 8),
          _buildSafetyCard(
            title: 'Earthquake Preparedness',
            subtitle: 'Identify safe spots in your house. Duck, cover, and hold during tremors.',
            icon: Icons.vibration,
            color: RiskColors.chartEarthquake,
          ),
          const SizedBox(height: 8),
          _buildSafetyCard(
            title: 'Extreme Heat Advisory',
            subtitle: 'Drink plenty of water. Rest in shaded areas. Monitor high-risk temperature zones.',
            icon: Icons.wb_sunny_rounded,
            color: RiskColors.chartHeat,
          ),
          const SizedBox(height: 8),
          _buildSafetyCard(
            title: 'Municipal Emergency Contacts',
            subtitle: 'Binalonan Rescue: (075) 562-2019\nPolice Hotline: 911\nFire Station: 0918-XXX-XXXX',
            icon: Icons.phone_in_talk_rounded,
            color: RiskColors.high,
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.15),
                  color.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: RiskColors.textPrimaryLight,
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: RiskColors.textSecondaryLight,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
