import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:b_risk/features/map/presentation/providers/map_providers.dart';
import 'package:b_risk/features/map/presentation/helpers/barangay_ui_helpers.dart';
import 'package:b_risk/core/theme/risk_colors.dart';

class BinalonanMapView extends ConsumerWidget {
  final MapController mapController;

  const BinalonanMapView({
    super.key,
    required this.mapController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barangays = ref.watch(barangaysProvider);
    final selectedBarangay = ref.watch(selectedBarangayProvider);
    final selectedFilter = ref.watch(riskFilterProvider);

    final filteredBarangays = barangays.where((b) {
      if (selectedFilter == 'All') return true;
      return b.riskLevel == selectedFilter;
    }).toList();

    final binalonanBounds = LatLngBounds(
      const LatLng(15.910000, 120.490000),
      const LatLng(16.160000, 120.710000),
    );

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: const LatLng(16.001363, 120.602654),
        initialZoom: 12.0,
        minZoom: 10.0,
        maxZoom: 18.0,
        cameraConstraint: CameraConstraint.contain(bounds: binalonanBounds),
      ),
      children: [
        // 1. Base Satellite Layer
        TileLayer(
          urlTemplate: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
          userAgentPackageName: 'com.yourcompany.binalonanapp',
          retinaMode: true,
          maxNativeZoom: 18,
        ),
        // 2. Transparent Labels Layer
        TileLayer(
          urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager_only_labels/{z}/{x}/{y}{r}.png',
          subdomains: const ['a', 'b', 'c', 'd'],
          userAgentPackageName: 'com.yourcompany.binalonanapp',
          retinaMode: true,
          maxNativeZoom: 18,
        ),
        // 3. Risk Markers
        MarkerLayer(
          markers: filteredBarangays.map((barangay) {
            final isSelected = selectedBarangay?.name == barangay.name;
            final isHovered = ref.watch(hoveredBarangayProvider)?.name == barangay.name;

            return Marker(
              point: barangay.coordinates,
              width: isHovered ? 210 : (isSelected ? 180 : 70),
              height: isHovered ? 150 : 70,
              alignment: Alignment.bottomCenter,
              child: MouseRegion(
                onEnter: (_) => ref.read(hoveredBarangayProvider.notifier).hover(barangay),
                onExit: (_) => ref.read(hoveredBarangayProvider.notifier).hover(null),
                child: GestureDetector(
                  onLongPressStart: (_) => ref.read(hoveredBarangayProvider.notifier).hover(barangay),
                  onLongPressEnd: (_) => ref.read(hoveredBarangayProvider.notifier).hover(null),
                  onLongPressCancel: () => ref.read(hoveredBarangayProvider.notifier).hover(null),
                  onTap: () {
                    ref.read(selectedBarangayProvider.notifier).select(barangay);
                    // Map controller move is handled in MapScreen listener now
                  },
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      // Pin & Pulse circle
                      Positioned(
                        bottom: 0,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            if (isSelected || isHovered)
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: barangay.riskColor.withValues(alpha: 0.15),
                                  border: Border.all(
                                    color: barangay.riskColor.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                              ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: barangay.riskColor,
                                border: Border.all(color: Colors.white, width: 2.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: barangay.riskColor.withValues(alpha: 0.5),
                                    blurRadius: isSelected || isHovered ? 16 : 8,
                                    offset: const Offset(0, 4),
                                    spreadRadius: isSelected || isHovered ? 2 : 0,
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Container(
                                width: isSelected || isHovered ? 20 : 16,
                                height: isSelected || isHovered ? 20 : 16,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.circle,
                                    size: isSelected || isHovered ? 8 : 6,
                                    color: barangay.riskColor,
                                  ),
                                ),
                              ),
                            ),
                            // Mini text beside the pinned marker when selected
                            if (isSelected && !isHovered)
                              Positioned(
                                left: 40,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    barangay.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: RiskColors.textPrimaryLight,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Hover Metadata Card
                      if (isHovered)
                        Positioned(
                          bottom: 56,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                width: 170,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.88),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: barangay.riskColor.withValues(alpha: 0.25),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      barangay.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                        color: RiskColors.textPrimaryLight,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: barangay.riskColor.withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            barangay.riskLevel,
                                            style: TextStyle(
                                              color: barangay.riskColor,
                                              fontSize: 9,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Icon(Icons.device_thermostat_rounded, size: 12, color: RiskColors.chartHeat),
                                        Text(
                                          '${barangay.temperature}°C',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: RiskColors.textSecondaryLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(Icons.people_alt_outlined, size: 11, color: RiskColors.textTertiaryLight),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${barangay.populationFormatted} pop.',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: RiskColors.textTertiaryLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}