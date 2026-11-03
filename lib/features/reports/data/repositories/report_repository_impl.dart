import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:b_risk/features/auth/domain/entities/app_user.dart';
import 'package:b_risk/features/reports/domain/entities/report.dart';
import 'package:b_risk/features/reports/domain/repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final FirebaseFirestore firestore;

  const ReportRepositoryImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _reports => firestore.collection('reports');

  static Report _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> d) {
    final json = d.data();
    return Report(
      id: d.id,
      reporterUid: json['reporterUid'] as String,
      reporterName: json['reporterName'] as String,
      reporterPhone: json['reporterPhone'] as String?,
      type: json['type'] as String,
      barangayName: json['barangayName'] as String,
      details: json['details'] as String,
      status: json['status'] as String,
      // null until the server stamps a just-sent report
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  @override
  Future<void> submit({
    required AppUser reporter,
    required String type,
    required String barangayName,
    required String details,
  }) {
    return _reports.add({
      'reporterUid': reporter.uid,
      'reporterName': reporter.name,
      'reporterPhone': ?reporter.phone,
      'type': type,
      'barangayName': barangayName,
      'details': details,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<Report>> watchMine(String uid) {
    // Sorted here so the query needs no composite index
    return _reports.where('reporterUid', isEqualTo: uid).snapshots().map(
          (snap) => snap.docs.map(_fromDoc).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
        );
  }

  @override
  Stream<List<Report>> watchAll() {
    return _reports
        .orderBy('createdAt', descending: true)
        .limit(200)
        .snapshots()
        .map((snap) => snap.docs.map(_fromDoc).toList());
  }

  @override
  Future<void> setStatus(String id, String status) => _reports.doc(id).update({'status': status});
}
