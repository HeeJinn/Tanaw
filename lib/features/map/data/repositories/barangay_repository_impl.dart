import 'package:b_risk/features/map/domain/entities/barangay.dart';
import 'package:b_risk/features/map/domain/repositories/barangay_repository.dart';
import 'package:b_risk/features/map/data/datasources/barangay_remote_data_source.dart';

class BarangayRepositoryImpl implements BarangayRepository {
  final BarangayRemoteDataSource remoteDataSource;

  const BarangayRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Stream<List<Barangay>> watchBarangays() {
    return remoteDataSource.watchBarangays();
  }
}
