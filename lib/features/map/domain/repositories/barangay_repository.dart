import 'package:b_risk/features/map/domain/entities/barangay.dart';

abstract class BarangayRepository {
  Stream<List<Barangay>> watchBarangays();
}
