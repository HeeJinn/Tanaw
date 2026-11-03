import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:b_risk/features/map/presentation/widgets/binalonan_map_view.dart';
import 'package:b_risk/features/map/presentation/widgets/barangay_bottom_sheet.dart';
import 'package:b_risk/features/map/presentation/helpers/barangay_ui_helpers.dart';
import 'package:b_risk/features/map/presentation/providers/map_providers.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();
  final SearchController _searchController = SearchController();

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Move the camera whenever a barangay is selected (search, marker or list tap)
    ref.listen(selectedBarangayProvider, (previous, next) {
      _searchController.text = next?.name ?? '';
      if (next != null) {
        _mapController.move(next.coordinates, 15.5);
      }
    });
    final selected = ref.watch(selectedBarangayProvider);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final sheetTop = constraints.maxHeight * kSheetMinSize;
          return Stack(
            children: [
              BinalonanMapView(
                mapController: _mapController,
                bottomPadding: sheetTop,
              ),

              // Search
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: SearchAnchor.bar(
                    searchController: _searchController,
                    barHintText: 'Search barangays',
                    barTrailing: [
                      if (selected != null)
                        IconButton(
                          tooltip: 'Clear selection',
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => ref
                              .read(selectedBarangayProvider.notifier)
                              .select(null),
                        ),
                    ],
                    suggestionsBuilder: (context, controller) {
                      final query = controller.text.toLowerCase();
                      final barangays = ref.read(barangaysProvider).value ?? const [];
                      return [
                        for (final b in barangays)
                          if (b.name.toLowerCase().contains(query))
                            ListTile(
                              leading: Icon(Icons.location_on_rounded, color: b.riskColor),
                              title: Text(b.name),
                              subtitle: Text('${b.riskLevel} risk · ${b.populationFormatted} people'),
                              onTap: () {
                                controller.closeView(b.name);
                                ref.read(selectedBarangayProvider.notifier).select(b);
                              },
                            ),
                      ];
                    },
                  ),
                ),
              ),

              // Reset view
              Positioned(
                right: 16,
                bottom: sheetTop + 16,
                child: FloatingActionButton(
                  heroTag: 'resetview',
                  tooltip: 'Reset map view',
                  onPressed: () => _mapController.move(kBinalonanCenter, 13.5),
                  child: const Icon(Icons.center_focus_strong_rounded),
                ),
              ),

              Positioned.fill(
                child: SafeArea(
                  bottom: false,
                  child: const BarangayBottomSheet(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
