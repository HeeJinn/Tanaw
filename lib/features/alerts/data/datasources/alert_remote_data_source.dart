import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:b_risk/features/alerts/data/models/alert_model.dart';

abstract class AlertRemoteDataSource {
  Stream<List<AlertModel>> watchAlerts();
}

class AlertRemoteDataSourceImpl implements AlertRemoteDataSource {
  final FirebaseFirestore firestore;

  const AlertRemoteDataSourceImpl({required this.firestore});

  @override
  Stream<List<AlertModel>> watchAlerts() {
    return firestore
        .collection('alerts')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => AlertModel.fromJson({...d.data(), 'id': d.id}))
            // Tanaw only covers flood and heat; skip anything else staff may have added
            .where((a) => a.type == 'flood' || a.type == 'heat')
            .toList());
  }
}
