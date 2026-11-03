import 'package:flutter/material.dart';
import 'package:material_new_shapes/material_new_shapes.dart';
import 'package:b_risk/core/theme/risk_colors.dart';
import 'package:b_risk/core/widgets/expressive.dart';

/// Half-width stat tile; place two in a Row.
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final RoundedPolygon shape;
  final Color color;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.shape,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Card.filled(
        color: theme.colorScheme.surfaceContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShapeIcon(icon: icon, shape: shape, color: color),
              const SizedBox(height: 16),
              Text(value, style: theme.textTheme.headlineMedium?.copyWith(color: RiskColors.readable(color, theme.brightness))),
              Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}
