import 'package:flutter/material.dart';
import 'package:material_new_shapes/material_new_shapes.dart';

/// Semantic colors, icons and shapes for risk levels and hazard types.
/// Everything else comes from the theme's ColorScheme.
class RiskColors {
  RiskColors._();

  // ── Risk Level Colors ──────────────────────────────────────────────
  static const Color high = Color(0xFFE5383B);
  static const Color medium = Color(0xFFF59E0B);
  static const Color low = Color(0xFF10B981);

  /// Seed for the app's ColorScheme.
  static const Color primary = Color(0xFF4F46E5);

  // ── Hazard Colors ──────────────────────────────────────────────────
  static const Color flood = Color(0xFF3B82F6);
  static const Color heat = Color(0xFFF97316);
  static const Color chartLine = Color(0xFF06B6D4);

  /// The colors above are tuned as fills; as text or icons they need a darker
  /// (light mode) or lighter (dark mode) shade to stay readable.
  static Color readable(Color color, Brightness brightness) => brightness == Brightness.light
      ? Color.lerp(color, Colors.black, 0.3)!
      : Color.lerp(color, Colors.white, 0.25)!;

  static Color colorForRisk(String riskLevel) {
    switch (riskLevel) {
      case 'High':
        return high;
      case 'Medium':
        return medium;
      case 'Low':
        return low;
      default:
        return primary;
    }
  }

  static IconData iconForRisk(String riskLevel) {
    switch (riskLevel) {
      case 'High':
        return Icons.warning_amber_rounded;
      case 'Medium':
        return Icons.shield_outlined;
      case 'Low':
        return Icons.verified_user_outlined;
      default:
        return Icons.gpp_maybe_rounded;
    }
  }

  /// Spikier shapes read as more urgent.
  static RoundedPolygon shapeForRisk(String riskLevel) {
    switch (riskLevel) {
      case 'High':
        return MaterialShapes.softBurst;
      case 'Medium':
        return MaterialShapes.cookie9Sided;
      default:
        return MaterialShapes.circle;
    }
  }

  static Color colorForHazard(String type) {
    switch (type) {
      case 'flood':
        return flood;
      case 'heat':
        return heat;
      default:
        return primary;
    }
  }

  static IconData iconForHazard(String type) {
    switch (type) {
      case 'flood':
        return Icons.water_drop_rounded;
      case 'heat':
        return Icons.wb_sunny_rounded;
      default:
        return Icons.warning_amber_rounded;
    }
  }
}
