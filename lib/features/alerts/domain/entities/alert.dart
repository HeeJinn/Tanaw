class Alert {
  final String id;
  final String title;
  final String description;
  final String severity; // 'High', 'Medium', 'Low'
  final String type; // 'flood', 'earthquake', 'heat'
  final String barangayName;
  final DateTime timestamp;
  final bool isRead;

  const Alert({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.type,
    required this.barangayName,
    required this.timestamp,
    this.isRead = false,
  });

  Alert copyWith({bool? isRead}) {
    return Alert(
      id: id,
      title: title,
      description: description,
      severity: severity,
      type: type,
      barangayName: barangayName,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}
