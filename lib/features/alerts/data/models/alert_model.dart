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
    super.isRead,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      severity: json['severity'] as String,
      type: json['type'] as String,
      barangayName: json['barangayName'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'severity': severity,
      'type': type,
      'barangayName': barangayName,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }
}
