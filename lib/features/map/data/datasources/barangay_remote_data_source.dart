import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:b_risk/features/map/data/models/barangay_model.dart';

abstract class BarangayRemoteDataSource {
  Stream<List<BarangayModel>> watchBarangays();
}

class BarangayRemoteDataSourceImpl implements BarangayRemoteDataSource {
  final FirebaseFirestore firestore;

  const BarangayRemoteDataSourceImpl({required this.firestore});

  @override
  Stream<List<BarangayModel>> watchBarangays() {
    return firestore
        .collection('barangays')
        .orderBy('name')
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => BarangayModel.fromJson(d.data())).toList());
  }
}
