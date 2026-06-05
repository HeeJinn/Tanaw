import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:b_risk/features/map/presentation/providers/map_providers.dart';
import 'package:b_risk/features/map/presentation/widgets/barangay_search_delegate.dart';
import 'package:b_risk/core/theme/risk_colors.dart';

class SearchOverlay extends ConsumerWidget {
  const SearchOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedBarangay = ref.watch(selectedBarangayProvider);

    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: GestureDetector(
        onTap: () async {
          final selected = await showSearch(
            context: context,
            delegate: BarangaySearchDelegate(ref),
          );
          if (selected != null) {
            ref.read(selectedBarangayProvider.notifier).select(selected);
          }
        },
        child: Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(27),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                selectedBarangay != null ? Icons.place_rounded : Icons.search_rounded,
                color: selectedBarangay != null ? RiskColors.primary : Colors.grey[600],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  selectedBarangay != null
                      ? selectedBarangay.name
                      : 'Search for a barangay...',
                  style: TextStyle(
                    color: selectedBarangay != null
                        ? Colors.black87
                        : Colors.grey[600],
                    fontSize: 16,
                    fontWeight: selectedBarangay != null ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (selectedBarangay != null)
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.grey, size: 22),
                  onPressed: () => ref.read(selectedBarangayProvider.notifier).select(null),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
              else
                Icon(Icons.tune_rounded, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }
}
