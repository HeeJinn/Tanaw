import 'package:flutter/material.dart';
import 'package:b_risk/core/theme/risk_colors.dart';
import 'package:b_risk/core/widgets/expressive.dart';
import 'package:b_risk/features/alerts/domain/entities/alert.dart';

class AlertCard extends StatelessWidget {
  final Alert alert;
  final VoidCallback? onTap;

  const AlertCard({
    super.key,
    required this.alert,
    this.onTap,
  });

  static String timeAgo(DateTime timestamp, DateTime now) {
    final diff = now.difference(timestamp);
    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final severityColor = RiskColors.readable(RiskColors.colorForRisk(alert.severity), theme.brightness);

    return Card.filled(
      color: alert.isRead ? scheme.surfaceContainerLow : scheme.surfaceContainerHighest,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShapeIcon(
                icon: RiskColors.iconForHazard(alert.type),
                shape: RiskColors.shapeForRisk(alert.severity),
                color: RiskColors.colorForHazard(alert.type),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          alert.severity.toUpperCase(),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: severityColor,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            ' · ${alert.barangayName}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ),
                        Text(
                          timeAgo(alert.timestamp, DateTime.now()),
                          style: theme.textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                        if (!alert.isRead) ...[
                          const SizedBox(width: 8),
                          Semantics(
                            label: 'Unread',
                            child: CircleAvatar(radius: 4, backgroundColor: scheme.primary),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      alert.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: alert.isRead ? FontWeight.w600 : FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      alert.description,
                      maxLines: 2,
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
