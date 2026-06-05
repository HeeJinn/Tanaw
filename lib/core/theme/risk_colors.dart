import 'package:flutter/material.dart';

/// Curated semantic risk color palette for the B-Risk design system.
/// Inspired by Tailwind CSS color scales for a premium, harmonious look.
class RiskColors {
  RiskColors._();

  // ── Risk Level Colors ──────────────────────────────────────────────
  static const Color high = Color(0xFFEF4444);       // Red-500
  static const Color highSurface = Color(0xFFFEE2E2); // Red-100
  static const Color highDark = Color(0xFFFCA5A5);    // Red-300 (dark mode)

  static const Color medium = Color(0xFFF59E0B);       // Amber-500
  static const Color mediumSurface = Color(0xFFFEF3C7); // Amber-100
  static const Color mediumDark = Color(0xFFFCD34D);    // Amber-300

  static const Color low = Color(0xFF10B981);         // Emerald-500
  static const Color lowSurface = Color(0xFFD1FAE5);  // Emerald-100
  static const Color lowDark = Color(0xFF6EE7B7);     // Emerald-300

  // ── Primary Accent ─────────────────────────────────────────────────
  static const Color primary = Color(0xFF6366F1);     // Indigo-500
  static const Color primaryLight = Color(0xFF818CF8); // Indigo-400
  static const Color primaryDark = Color(0xFF4F46E5);  // Indigo-600
  static const Color primarySurface = Color(0xFFE0E7FF); // Indigo-100

  // ── Neutral Surface ────────────────────────────────────────────────
  static const Color surfaceLight = Color(0xFFF8FAFC);  // Slate-50
  static const Color surfaceMid = Color(0xFFF1F5F9);    // Slate-100
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE2E8F0);   // Slate-200

  static const Color surfaceDark = Color(0xFF0F172A);    // Slate-900
  static const Color surfaceDarkMid = Color(0xFF1E293B); // Slate-800
  static const Color cardDark = Color(0xFF1E293B);       // Slate-800
  static const Color borderDark = Color(0xFF334155);     // Slate-700

  // ── Text ───────────────────────────────────────────────────────────
  static const Color textPrimaryLight = Color(0xFF0F172A);  // Slate-900
  static const Color textSecondaryLight = Color(0xFF64748B); // Slate-500
  static const Color textTertiaryLight = Color(0xFF94A3B8);  // Slate-400

  static const Color textPrimaryDark = Color(0xFFF1F5F9);   // Slate-100
  static const Color textSecondaryDark = Color(0xFF94A3B8);  // Slate-400
  static const Color textTertiaryDark = Color(0xFF64748B);   // Slate-500

  // ── Chart-specific ─────────────────────────────────────────────────
  static const Color chartFlood = Color(0xFF3B82F6);    // Blue-500
  static const Color chartEarthquake = Color(0xFF8B5CF6); // Violet-500
  static const Color chartHeat = Color(0xFFF97316);     // Orange-500
  static const Color chartLine = Color(0xFF06B6D4);     // Cyan-500
  static const Color chartLineFill = Color(0x2006B6D4); // Cyan-500 @ 12%
  static const Color chartGrid = Color(0xFFE2E8F0);     // Slate-200
  static const Color chartGridDark = Color(0xFF334155);  // Slate-700

  /// Returns the curated color for a given risk level string.
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

  /// Returns a surface-tinted color for a risk level (for card backgrounds).
  static Color surfaceForRisk(String riskLevel) {
    switch (riskLevel) {
      case 'High':
        return highSurface;
      case 'Medium':
        return mediumSurface;
      case 'Low':
        return lowSurface;
      default:
        return primarySurface;
    }
  }

  /// Returns a gradient for the given risk level.
  static LinearGradient gradientForRisk(String riskLevel) {
    final color = colorForRisk(riskLevel);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color,
        color.withValues(alpha: 0.7),
      ],
    );
  }

  /// Returns the icon for a given risk level.
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
}
