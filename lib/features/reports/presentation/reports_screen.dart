import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_new_shapes/material_new_shapes.dart';
import 'package:b_risk/core/contacts.dart';
import 'package:b_risk/core/theme/risk_colors.dart';
import 'package:b_risk/core/widgets/expressive.dart';
import 'package:b_risk/features/alerts/presentation/widgets/alert_card.dart';
import 'package:b_risk/features/auth/presentation/providers/auth_providers.dart';
import 'package:b_risk/features/reports/domain/entities/report.dart';
import 'package:b_risk/features/reports/presentation/providers/report_providers.dart';
import 'package:b_risk/features/reports/presentation/widgets/report_form.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportsProvider);
    final user = ref.watch(currentUserProvider).value;
    final isAdmin = user?.isAdmin ?? false;

    return Scaffold(
      // Hidden until the role is known, so admins never see it flash in
      floatingActionButton: user == null || isAdmin
          ? null
          : FloatingActionButton.extended(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (_) => const ReportForm(),
              ),
              icon: const Icon(Icons.add_rounded),
              label: const Text('New report'),
            ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(title: Text(isAdmin ? 'All reports' : 'My reports')),
          ...reports.when(
            loading: () => [const SliverFillRemaining(hasScrollBody: false, child: LoadingState())],
            error: (error, _) => [
              SliverFillRemaining(
                hasScrollBody: false,
                child: ErrorState(
                  message: "Couldn't load reports. Check your connection.",
                  onRetry: () => ref.invalidate(reportsProvider),
                ),
              ),
            ],
            data: (reports) => [
              if (reports.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(isAdmin: isAdmin),
                )
              else
                SliverPadding(
                  // Bottom space keeps the last card clear of the FAB
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                  sliver: SliverList.separated(
                    itemCount: reports.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, i) => _ReportCard(
                      report: reports[i],
                      onTap: isAdmin ? () => _showAdminSheet(context, ref, reports[i]) : null,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAdminSheet(BuildContext context, WidgetRef ref, Report report) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(report.reporterName, style: theme.textTheme.headlineSmall),
              Text(
                '${_typeLabel(report.type)} · ${report.barangayName} · ${AlertCard.timeAgo(report.createdAt, DateTime.now())}',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              Text(report.details, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 24),
              Text('Status', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: [
                  for (final s in Report.statuses) ButtonSegment(value: s, label: Text(_statusLabel(s))),
                ],
                selected: {report.status},
                onSelectionChanged: (s) {
                  ref.read(reportRepositoryProvider).setStatus(report.id, s.first);
                  Navigator.pop(sheetContext);
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        context.go('/messages/${report.reporterUid}');
                      },
                      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                      icon: const Icon(Icons.chat_rounded),
                      label: const Text('Message'),
                    ),
                  ),
                  if (report.reporterPhone != null) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => callNumber(report.reporterPhone!),
                        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                        icon: const Icon(Icons.call_rounded),
                        label: const Text('Call'),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

String _typeLabel(String type) => type == 'flood' ? 'Flood' : 'Heat';

String _statusLabel(String status) => switch (status) {
      'reviewing' => 'Reviewing',
      'resolved' => 'Resolved',
      _ => 'Pending',
    };

class _ReportCard extends StatelessWidget {
  final Report report;
  final VoidCallback? onTap;

  const _ReportCard({required this.report, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final statusColor = switch (report.status) {
      'reviewing' => RiskColors.medium,
      'resolved' => RiskColors.low,
      _ => scheme.outline,
    };

    return Card.filled(
      color: scheme.surfaceContainer,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShapeIcon(
                icon: RiskColors.iconForHazard(report.type),
                shape: MaterialShapes.cookie7Sided,
                color: RiskColors.colorForHazard(report.type),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${_typeLabel(report.type)} · ${report.barangayName}',
                            style: theme.textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: ShapeDecoration(
                            shape: const StadiumBorder(),
                            color: statusColor.withValues(alpha: 0.16),
                          ),
                          child: Text(
                            _statusLabel(report.status),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: RiskColors.readable(statusColor, theme.brightness),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${report.reporterName} · ${AlertCard.timeAgo(report.createdAt, DateTime.now())}',
                      style: theme.textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      report.details,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isAdmin;

  const _EmptyState({required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShapeIcon(
              icon: Icons.assignment_rounded,
              shape: MaterialShapes.clover8Leaf,
              color: theme.colorScheme.primary,
              size: 88,
            ),
            const SizedBox(height: 16),
            Text('No reports yet', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(
              isAdmin
                  ? 'Reports from residents will show up here.'
                  : 'Seen flooding or dangerous heat? Tap New report to tell the MDRRMO.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
