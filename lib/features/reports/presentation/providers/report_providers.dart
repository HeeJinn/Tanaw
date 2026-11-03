import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:b_risk/features/auth/presentation/providers/auth_providers.dart';
import 'package:b_risk/features/reports/data/repositories/report_repository_impl.dart';
import 'package:b_risk/features/reports/domain/entities/report.dart';
import 'package:b_risk/features/reports/domain/repositories/report_repository.dart';

part 'report_providers.g.dart';

@riverpod
ReportRepository reportRepository(Ref ref) {
  return ReportRepositoryImpl(firestore: FirebaseFirestore.instance);
}

/// Admins see every report; residents see their own.
@riverpod
Stream<List<Report>> reports(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return const Stream.empty();
  final repo = ref.watch(reportRepositoryProvider);
  return user.isAdmin ? repo.watchAll() : repo.watchMine(user.uid);
}
