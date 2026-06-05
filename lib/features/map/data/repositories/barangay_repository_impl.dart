import 'package:b_risk/features/map/domain/entities/barangay.dart';
import 'package:b_risk/features/map/domain/repositories/barangay_repository.dart';
import 'package:b_risk/features/map/data/datasources/barangay_local_data_source.dart';

class BarangayRepositoryImpl implements BarangayRepository {
  final BarangayLocalDataSource localDataSource;

  const BarangayRepositoryImpl({
    required this.localDataSource,
  });

  @override
  List<Barangay> getBarangays() {
    return localDataSource.getBarangays();
  }
}
