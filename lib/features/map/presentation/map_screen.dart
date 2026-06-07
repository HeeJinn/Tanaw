import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:b_risk/features/map/presentation/widgets/binalonan_map_view.dart';
import 'package:b_risk/features/map/presentation/widgets/search_overlay.dart';
import 'package:b_risk/features/map/presentation/widgets/barangay_bottom_sheet.dart';
import 'package:b_risk/features/map/presentation/providers/map_providers.dart';
import 'package:b_risk/core/theme/risk_colors.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Automatically move camera when a barangay is selected (e.g., via search or tap)
    ref.listen(selectedBarangayProvider, (previous, next) {
      if (next != null) {
        _mapController.move(next.coordinates, 15.5);
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          // 1. Map
          BinalonanMapView(mapController: _mapController),

          // 2. Top gradient overlay for search bar readability
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).padding.top + 80,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.35),
                      Colors.black.withValues(alpha: 0.12),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // 3. Search Bar Overlay
          const SearchOverlay(),

          // 4. Floating Action Button — Reset view
          Positioned(
            bottom: 140,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: RiskColors.primary.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: FloatingActionButton.small(
                    heroTag: 'mylocation',
                    backgroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: RiskColors.borderLight.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.my_location_rounded,
                      color: RiskColors.primary,
                      size: 20,
                    ),
                    onPressed: () {
                      _mapController.move(const LatLng(16.0500, 120.5950), 13.5);
                    },
                  ),
                ),
              ],
            ),
          ),

          // 5. Interactive Bottom Sheet
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: BarangayBottomSheet(mapController: _mapController),
            ),
          ),
        ],
      ),
    );
  }
}