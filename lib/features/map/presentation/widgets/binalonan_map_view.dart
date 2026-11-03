import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:b_risk/features/map/presentation/providers/map_providers.dart';
import 'package:b_risk/features/map/presentation/helpers/barangay_ui_helpers.dart';

const kBinalonanCenter = LatLng(16.0500, 120.5950);

class BinalonanMapView extends ConsumerWidget {
  final MapController mapController;

  /// Space the bottom sheet covers, so attribution stays visible.
  final double bottomPadding;

  const BinalonanMapView({
    super.key,
    required this.mapController,
    this.bottomPadding = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barangays = ref.watch(filteredBarangaysProvider).value ?? const [];
    final selected = ref.watch(selectedBarangayProvider);
    final theme = Theme.of(context);

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: selected?.coordinates ?? kBinalonanCenter,
        initialZoom: selected == null ? 12.0 : 15.5,
        minZoom: 10.0,
        maxZoom: 18.0,
        cameraConstraint: CameraConstraint.contain(
          bounds: LatLngBounds(
            const LatLng(15.91, 120.49),
            const LatLng(16.16, 120.71),
          ),
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
          userAgentPackageName: 'com.example.tanaw',
          retinaMode: true,
          maxNativeZoom: 18,
        ),
        // Place names on top of the imagery (CARTO's labels now need an API key)
        TileLayer(
          urlTemplate: 'https://server.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/{z}/{y}/{x}',
          userAgentPackageName: 'com.example.tanaw',
          maxNativeZoom: 18,
        ),
        MarkerLayer(
          markers: [
            for (final b in barangays)
              Marker(
                point: b.coordinates,
                width: 40,
                height: 40,
                child: Semantics(
                  button: true,
                  label: '${b.name}, ${b.riskLevel} risk',
                  child: GestureDetector(
                    onTap: () => ref.read(selectedBarangayProvider.notifier).select(b),
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        AnimatedContainer(
                          duration: Durations.medium2,
                          curve: Curves.easeOutBack,
                          width: b.name == selected?.name ? 36 : 22,
                          height: b.name == selected?.name ? 36 : 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: b.riskColor,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: const [
                              BoxShadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 2)),
                            ],
                          ),
                          child: b.name == selected?.name
                              ? Icon(b.riskIcon, size: 16, color: Colors.white)
                              : null,
                        ),
                        if (b.name == selected?.name)
                          Positioned(
                            left: 44,
                            child: Material(
                              color: theme.colorScheme.surfaceContainerHighest,
                              shape: const StadiumBorder(),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                child: Text(b.name, style: theme.textTheme.labelLarge, softWrap: false),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: RichAttributionWidget(
            alignment: AttributionAlignment.bottomLeft,
            attributions: const [
              TextSourceAttribution('Esri, Maxar, Earthstar Geographics, and the GIS User Community'),
            ],
          ),
        ),
      ],
    );
  }
}
