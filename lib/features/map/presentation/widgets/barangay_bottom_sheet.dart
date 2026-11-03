import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_new_shapes/material_new_shapes.dart';
import 'package:b_risk/core/contacts.dart';
import 'package:b_risk/core/theme/risk_colors.dart';
import 'package:b_risk/core/widgets/expressive.dart';
import 'package:b_risk/features/map/domain/entities/barangay.dart';
import 'package:b_risk/features/map/presentation/providers/map_providers.dart';
import 'package:b_risk/features/map/presentation/helpers/barangay_ui_helpers.dart';
import 'package:b_risk/features/map/presentation/widgets/charts/risk_bar_chart.dart';
import 'package:b_risk/features/map/presentation/widgets/charts/temperature_line_chart.dart';

/// Collapsed height of the sheet, as a fraction of the map screen.
const kSheetMinSize = 0.16;

class BarangayBottomSheet extends ConsumerStatefulWidget {
  const BarangayBottomSheet({super.key});

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

  void _showDetail() {
    if (_sheetController.isAttached) {
      _sheetController.animateTo(0.5, duration: Durations.medium4, curve: Easing.emphasizedDecelerate);
    }
    if (_innerScrollController?.hasClients ?? false) {
      _innerScrollController!.animateTo(0, duration: Durations.medium4, curve: Easing.emphasizedDecelerate);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(selectedBarangayProvider, (previous, next) {
      if (next != null) _showDetail();
    });
    final selected = ref.watch(selectedBarangayProvider);
    final filter = ref.watch(riskFilterProvider);
    final filtered = ref.watch(filteredBarangaysProvider);
    final total = ref.watch(barangaysProvider).value?.length;
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: kSheetMinSize,
      minChildSize: kSheetMinSize,
      maxChildSize: 1.0,
      snap: true,
      snapSizes: const [0.5],
      builder: (context, scrollController) {
        _innerScrollController = scrollController;
        return Material(
          color: theme.colorScheme.surfaceContainerLow,
          elevation: 3,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          clipBehavior: Clip.antiAlias,
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 32,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: selected == null
                    ? _Header(
                        title: 'Barangays',
                        subtitle: total == null ? 'Binalonan, Pangasinan' : '$total areas monitored in Binalonan',
                      )
                    : _Header(
                        title: selected.name,
                        subtitle: '${selected.riskLevel} risk zone · ${selected.temperature}°C',
                        leading: ShapeIcon(
                          icon: selected.riskIcon,
                          shape: selected.riskShape,
                          color: selected.riskColor,
                          size: 52,
                        ),
                        trailing: IconButton.filledTonal(
                          tooltip: 'Close details',
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => ref.read(selectedBarangayProvider.notifier).select(null),
                        ),
                      ),
              ),
              if (selected != null) SliverToBoxAdapter(child: _SelectedDetail(barangay: selected)),

              // Risk filter
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      for (final level in const ['All', 'High', 'Medium', 'Low'])
                        ChoiceChip(
                          label: Text(level),
                          selected: filter == level,
                          avatar: level == 'All'
                              ? null
                              : CircleAvatar(backgroundColor: RiskColors.colorForRisk(level), radius: 6),
                          onSelected: (_) => ref.read(riskFilterProvider.notifier).setFilter(level),
                        ),
                    ],
                  ),
                ),
              ),

              filtered.when(
                data: (barangays) {
                  final others = barangays.where((b) => b.name != selected?.name).toList();
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList.separated(
                      itemCount: others.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 2),
                      itemBuilder: (context, i) => _BarangayTile(
                        barangay: others[i],
                        borderRadius: groupedRadius(i, others.length),
                        onTap: () => ref.read(selectedBarangayProvider.notifier).select(others[i]),
                      ),
                    ),
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: Padding(padding: EdgeInsets.all(32), child: LoadingState()),
                ),
                error: (error, _) => SliverToBoxAdapter(
                  child: ErrorState(
                    message: "Couldn't load barangays. Check your connection.",
                    onRetry: () => ref.invalidate(barangaysProvider),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: _SafetyGuidelines()),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? leading;
  final Widget? trailing;

  const _Header({required this.title, required this.subtitle, this.leading, this.trailing});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 16, 8),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 14)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.headlineSmall),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class _SelectedDetail extends StatelessWidget {
  final Barangay barangay;

  const _SelectedDetail({required this.barangay});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        children: [
          Row(
            children: [
              _StatTile(icon: Icons.people_alt_rounded, label: 'Population', value: barangay.populationFormatted),
              const SizedBox(width: 8),
              _StatTile(icon: Icons.device_thermostat_rounded, label: 'Temperature', value: '${barangay.temperature}°'),
              const SizedBox(width: 8),
              _StatTile(
                icon: Icons.speed_rounded,
                label: 'Avg risk',
                value: '${(barangay.averageRisk * 100).toStringAsFixed(0)}%',
                color: barangay.riskColor,
              ),
            ],
          ),
          const SizedBox(height: 8),
          _ChartCard(
            title: 'Risk breakdown',
            subtitle: 'Flood and heat',
            child: RiskBarChart(barangay: barangay),
          ),
          const SizedBox(height: 8),
          _ChartCard(
            title: 'Temperature trend',
            subtitle: 'Monthly average, last 6 months',
            child: TemperatureLineChart(barangay: barangay),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const _StatTile({required this.icon, required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tint = color == null ? theme.colorScheme.primary : RiskColors.readable(color!, theme.brightness);
    return Expanded(
      child: Card.filled(
        color: theme.colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, color: tint),
              const SizedBox(height: 6),
              Text(value, style: theme.textTheme.titleLarge?.copyWith(color: tint)),
              Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _ChartCard({required this.title, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card.filled(
      color: theme.colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            child,
          ],
        ),
      ),
    );
  }
}

class _BarangayTile extends StatelessWidget {
  final Barangay barangay;
  final BorderRadius borderRadius;
  final VoidCallback onTap;

  const _BarangayTile({required this.barangay, required this.borderRadius, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
        leading: ShapeIcon(
          icon: barangay.riskIcon,
          shape: barangay.riskShape,
          color: barangay.riskColor,
          size: 44,
        ),
        title: Text(barangay.name, style: theme.textTheme.titleMedium),
        subtitle: Text(
          '${barangay.riskLevel} risk · ${barangay.temperature}°C · ${barangay.populationFormatted} people',
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}

class _SafetyGuidelines extends StatelessWidget {
  const _SafetyGuidelines();

  static const _items = [
    (
      icon: Icons.waves_rounded,
      color: RiskColors.flood,
      title: 'Flood',
      body: 'Pack essential supplies and move to the evacuation centers in Poblacion and Bued.',
    ),
    (
      icon: Icons.wb_sunny_rounded,
      color: RiskColors.heat,
      title: 'Extreme heat',
      body: 'Drink plenty of water, rest in the shade, and check on elderly neighbors.',
    ),
    (
      icon: Icons.phone_in_talk_rounded,
      color: RiskColors.high,
      title: 'Emergency contacts',
      body: 'National emergency hotline: 911\nBinalonan Rescue: $kRescueHotline (tap to call)',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text('Stay safe', style: theme.textTheme.titleLarge),
          ),
          for (final (i, item) in _items.indexed) ...[
            if (i > 0) const SizedBox(height: 2),
            Material(
              color: theme.colorScheme.surfaceContainerHigh,
              shape: RoundedRectangleBorder(borderRadius: groupedRadius(i, _items.length)),
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
                leading: ShapeIcon(icon: item.icon, shape: MaterialShapes.cookie7Sided, color: item.color, size: 44),
                title: Text(item.title, style: theme.textTheme.titleMedium),
                subtitle: Text(item.body),
                onTap: item.icon == Icons.phone_in_talk_rounded ? () => callNumber(kRescueHotline) : null,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
