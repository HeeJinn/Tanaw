import 'package:latlong2/latlong.dart';

class Barangay {
  final String name;
  final LatLng coordinates;
  final String riskLevel;
  final double temperature;
  final int population;
  final double floodRisk;
  final double earthquakeRisk;
  final double heatRisk;
  final List<double> historicalTemperatures;

  const Barangay({
    required this.name,
    required this.coordinates,
    required this.riskLevel,
    required this.temperature,
    required this.population,
    required this.floodRisk,
    required this.earthquakeRisk,
    required this.heatRisk,
    required this.historicalTemperatures,
  });
}
