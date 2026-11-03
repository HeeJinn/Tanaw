import 'package:b_risk/features/auth/domain/entities/app_user.dart';
import 'package:b_risk/features/reports/domain/entities/report.dart';

abstract class ReportRepository {
  Future<void> submit({
    required AppUser reporter,
    required String type,
    required String barangayName,
    required String details,
  });

  /// Newest first.
  Stream<List<Report>> watchMine(String uid);

  /// Every report, newest first. Admins only.
  Stream<List<Report>> watchAll();

  Future<void> setStatus(String id, String status);
}
