import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:b_risk/features/alerts/domain/entities/alert.dart';

class AlertModel extends Alert {
  const AlertModel({
    required super.id,
    required super.title,
    required super.description,
    required super.severity,
    required super.type,
    required super.barangayName,
    required super.timestamp,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      severity: json['severity'] as String,
      type: json['type'] as String,
      barangayName: json['barangayName'] as String,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }
}
