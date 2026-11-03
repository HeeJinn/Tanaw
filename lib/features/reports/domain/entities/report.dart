/// A resident's hazard report. Staff move it through
/// pending → reviewing → resolved.
class Report {
  final String id;
  final String reporterUid;
  final String reporterName;
  final String? reporterPhone;
  final String type; // 'flood', 'heat'
  final String barangayName;
  final String details;
  final String status; // 'pending', 'reviewing', 'resolved'
  final DateTime createdAt;

  const Report({
    required this.id,
    required this.reporterUid,
    required this.reporterName,
    this.reporterPhone,
    required this.type,
    required this.barangayName,
    required this.details,
    required this.status,
    required this.createdAt,
  });

  static const statuses = ['pending', 'reviewing', 'resolved'];
}
