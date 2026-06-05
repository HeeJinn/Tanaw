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
    required super.earthquakeRisk,
    required super.heatRisk,
    required super.historicalTemperatures,
  });

  factory BarangayModel.fromJson(Map<String, dynamic> json) {
    return BarangayModel(
      name: json['name'] as String,
      coordinates: LatLng(json['lat'] as double, json['lng'] as double),
      riskLevel: json['riskLevel'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      population: json['population'] as int,
      floodRisk: (json['floodRisk'] as num).toDouble(),
      earthquakeRisk: (json['earthquakeRisk'] as num).toDouble(),
      heatRisk: (json['heatRisk'] as num).toDouble(),
      historicalTemperatures: (json['historicalTemperatures'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lat': coordinates.latitude,
      'lng': coordinates.longitude,
      'riskLevel': riskLevel,
      'temperature': temperature,
      'population': population,
      'floodRisk': floodRisk,
      'earthquakeRisk': earthquakeRisk,
      'heatRisk': heatRisk,
      'historicalTemperatures': historicalTemperatures,
    };
  }
}
