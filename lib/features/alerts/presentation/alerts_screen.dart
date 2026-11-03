import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_new_shapes/material_new_shapes.dart';
import 'package:b_risk/core/theme/risk_colors.dart';
import 'package:b_risk/core/widgets/expressive.dart';
import 'package:b_risk/features/alerts/domain/entities/alert.dart';
import 'package:b_risk/features/alerts/presentation/providers/alert_providers.dart';
import 'package:b_risk/features/alerts/presentation/widgets/alert_card.dart';

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  static const _filters = [
    (key: 'All', label: 'All'),
    (key: 'flood', label: 'Flood'),
    (key: 'heat', label: 'Heat'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(filteredAlertsProvider);
    final unreadCount = ref.watch(unreadAlertsCountProvider);
    final currentFilter = ref.watch(alertTypeFilterProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Alerts'),
            actions: [
              if (unreadCount > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: TextButton.icon(
                    onPressed: () => ref.read(readAlertIdsProvider.notifier).markAsRead(
                          (ref.read(alertListProvider).value ?? const []).map((a) => a.id),
                        ),
                    icon: const Icon(Icons.done_all_rounded),
                    label: const Text('Mark all read'),
                  ),
                ),
            ],
          ),

          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                spacing: 8,
                children: [
                  for (final f in _filters)
                    ChoiceChip(
                      label: Text(f.label),
                      avatar: f.key == 'All'
                          ? null
                          : Icon(
                              RiskColors.iconForHazard(f.key),
                              color: RiskColors.readable(RiskColors.colorForHazard(f.key), Theme.of(context).brightness),
                            ),
                      selected: currentFilter == f.key,
                      onSelected: (_) => ref.read(alertTypeFilterProvider.notifier).setFilter(f.key),
                    ),
                ],
              ),
            ),
          ),

          ...alerts.when(
            loading: () => [const SliverFillRemaining(hasScrollBody: false, child: LoadingState())],
            error: (error, _) => [
              SliverFillRemaining(
                hasScrollBody: false,
                child: ErrorState(
                  message: "Couldn't load alerts. Check your connection.",
                  onRetry: () => ref.invalidate(alertsProvider),
                ),
              ),
            ],
            data: (alerts) => [
              if (alerts.isEmpty)
                SliverFillRemaining(hasScrollBody: false, child: _buildEmptyState(context))
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverList.separated(
                    itemCount: alerts.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final alert = alerts[index];
                      return AlertCard(
                        alert: alert,
                        onTap: () {
                          if (!alert.isRead) {
                            ref.read(readAlertIdsProvider.notifier).markAsRead([alert.id]);
                          }
                          _showAlertDetail(context, alert);
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShapeIcon(
            icon: Icons.notifications_off_rounded,
            shape: MaterialShapes.clover8Leaf,
            color: RiskColors.low,
            size: 88,
          ),
          const SizedBox(height: 16),
          Text('All clear', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            'No alerts match this filter',
            style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  void _showAlertDetail(BuildContext context, Alert alert) {
    final theme = Theme.of(context);
    final severityColor = RiskColors.readable(RiskColors.colorForRisk(alert.severity), theme.brightness);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ShapeIcon(
                  icon: RiskColors.iconForHazard(alert.type),
                  shape: RiskColors.shapeForRisk(alert.severity),
                  color: RiskColors.colorForHazard(alert.type),
                  size: 56,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${alert.severity} priority',
                        style: theme.textTheme.titleSmall?.copyWith(color: severityColor),
                      ),
                      Text(
                        '${alert.barangayName} · ${AlertCard.timeAgo(alert.timestamp, DateTime.now())}',
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(alert.title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(alert.description, style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
                child: const Text('Got it'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
