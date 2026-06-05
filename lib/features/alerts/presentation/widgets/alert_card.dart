import 'package:flutter/material.dart';
import 'package:b_risk/features/alerts/domain/entities/alert.dart';
import 'package:b_risk/core/theme/risk_colors.dart';

class AlertCard extends StatelessWidget {
  final Alert alert;
  final VoidCallback? onTap;

  const AlertCard({
    super.key,
    required this.alert,
    this.onTap,
  });

  Color get _severityColor {
    switch (alert.severity) {
      case 'High':
        return RiskColors.high;
      case 'Medium':
        return RiskColors.medium;
      case 'Low':
        return RiskColors.low;
      default:
        return RiskColors.primary;
    }
  }

  IconData get _typeIcon {
    switch (alert.type) {
      case 'flood':
        return Icons.water_drop_rounded;
      case 'earthquake':
        return Icons.vibration;
      case 'heat':
        return Icons.wb_sunny_rounded;
      default:
        return Icons.warning_amber_rounded;
    }
  }

  Color get _typeColor {
    switch (alert.type) {
      case 'flood':
        return RiskColors.chartFlood;
      case 'earthquake':
        return RiskColors.chartEarthquake;
      case 'heat':
        return RiskColors.chartHeat;
      default:
        return RiskColors.primary;
    }
  }

  String get _timeAgo {
    final diff = DateTime.now().difference(alert.timestamp);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: alert.isRead
                ? Colors.white.withValues(alpha: 0.7)
                : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: alert.isRead
                  ? RiskColors.borderLight
                  : _severityColor.withValues(alpha: 0.25),
              width: alert.isRead ? 1 : 1.5,
            ),
            boxShadow: alert.isRead
                ? []
                : [
                    BoxShadow(
                      color: _severityColor.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left severity + type indicator
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _typeColor.withValues(alpha: 0.15),
                          _typeColor.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_typeIcon, color: _typeColor, size: 20),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _severityColor,
                          _severityColor.withValues(alpha: 0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Severity badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _severityColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            alert.severity,
                            style: TextStyle(
                              color: _severityColor,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Barangay name
                        Text(
                          alert.barangayName,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: RiskColors.textTertiaryLight,
                          ),
                        ),
                        const Spacer(),
                        // Timestamp
                        Text(
                          _timeAgo,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: RiskColors.textTertiaryLight,
                          ),
                        ),
                        // Unread dot
                        if (!alert.isRead) ...[
                          const SizedBox(width: 6),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _severityColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _severityColor.withValues(alpha: 0.4),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Title
                    Text(
                      alert.title,
                      style: TextStyle(
                        fontWeight:
                            alert.isRead ? FontWeight.w600 : FontWeight.w700,
                        fontSize: 14,
                        color: alert.isRead
                            ? RiskColors.textSecondaryLight
                            : RiskColors.textPrimaryLight,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Description
                    Text(
                      alert.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: RiskColors.textTertiaryLight,
                        height: 1.4,
                      ),
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
