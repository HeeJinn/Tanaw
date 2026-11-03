import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:b_risk/core/theme/risk_colors.dart';
import 'package:b_risk/core/widgets/expressive.dart';
import 'package:b_risk/features/map/domain/entities/barangay.dart';
import 'package:b_risk/features/map/presentation/helpers/barangay_ui_helpers.dart';
import 'package:b_risk/features/map/presentation/providers/map_providers.dart';

/// Carousel of high-risk barangays; tapping one opens it on the map.
class HighRiskAreasList extends ConsumerWidget {
  final List<Barangay> barangays;

  const HighRiskAreasList({super.key, required this.barangays});

  static const _cardWidth = 200.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final areas = barangays.where((b) => b.riskLevel == 'High').toList()
      ..sort((a, b) => b.averageRisk.compareTo(a.averageRisk));

    if (areas.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text('Needs attention', style: theme.textTheme.titleLarge),
        ),
        SizedBox(
          height: 168,
          child: CarouselView(
            itemExtent: _cardWidth,
            shrinkExtent: 120,
            backgroundColor: RiskColors.high.withValues(alpha: 0.14),
            onTap: (i) {
              ref.read(selectedBarangayProvider.notifier).select(areas[i]);
              StatefulNavigationShell.of(context).goBranch(1);
            },
            children: [
              for (final area in areas)
                // Keep content at full width while the carousel squeezes edge items
                OverflowBox(
                  minWidth: _cardWidth,
                  maxWidth: _cardWidth,
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShapeIcon(icon: area.riskIcon, shape: area.riskShape, color: RiskColors.high, size: 44),
                        const Spacer(),
                        Text(
                          area.name,
                          style: theme.textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${(area.averageRisk * 100).toStringAsFixed(0)}% risk · ${area.temperature}°C',
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
