import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:b_risk/features/map/domain/entities/barangay.dart';
import 'package:b_risk/features/map/presentation/providers/map_providers.dart';
import 'package:b_risk/features/map/presentation/helpers/barangay_ui_helpers.dart';
import 'package:b_risk/core/theme/risk_colors.dart';

class BarangaySearchDelegate extends SearchDelegate<Barangay?> {
  final WidgetRef ref;

  BarangaySearchDelegate(this.ref) : super(searchFieldLabel: 'Search barangays...');

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: RiskColors.textPrimaryLight),
        titleTextStyle: const TextStyle(
          color: RiskColors.textPrimaryLight,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: RiskColors.textTertiaryLight,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear_rounded, color: RiskColors.textSecondaryLight),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: RiskColors.textSecondaryLight),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    final barangays = ref.read(barangaysProvider);
    final suggestions = barangays.where((b) {
      final nameLower = b.name.toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower);
    }).toList();

    if (suggestions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: RiskColors.textTertiaryLight),
            const SizedBox(height: 16),
            Text(
              'No barangays found',
              style: TextStyle(color: RiskColors.textSecondaryLight, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final barangay = suggestions[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: barangay.riskColor.withValues(alpha: 0.15),
            ),
            child: Icon(
              Icons.location_on_rounded,
              color: barangay.riskColor,
              size: 20,
            ),
          ),
          title: Text(
            barangay.name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: RiskColors.textPrimaryLight,
            ),
          ),
          subtitle: Text(
            '${barangay.riskLevel} Risk • ${barangay.populationFormatted} pop',
            style: TextStyle(
              fontSize: 12,
              color: RiskColors.textSecondaryLight,
            ),
          ),
          onTap: () {
            close(context, barangay);
          },
        );
      },
    );
  }
}
