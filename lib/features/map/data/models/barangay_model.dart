import 'package:latlong2/latlong.dart';
import 'package:b_risk/features/map/domain/entities/barangay.dart';

class BarangayModel extends Barangay {
  const BarangayModel({
    required super.name,
    required super.coordinates,
    required super.riskLevel,
    required super.temperature,
    required super.population,
    required super.floodRisk,
    required super.heatRisk,
    required super.historicalTemperatures,
  });

  /// Firestore and JSON both hand numbers back as int or double, so read them as num.
  factory BarangayModel.fromJson(Map<String, dynamic> json) {
    return BarangayModel(
      name: json['name'] as String,
      coordinates: LatLng(
        (json['lat'] as num).toDouble(),
        (json['lng'] as num).toDouble(),
      ),
      riskLevel: json['riskLevel'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      population: (json['population'] as num).toInt(),
      floodRisk: (json['floodRisk'] as num).toDouble(),
      heatRisk: (json['heatRisk'] as num).toDouble(),
      historicalTemperatures: (json['historicalTemperatures'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }
}
