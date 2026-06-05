import 'package:b_risk/features/alerts/data/models/alert_model.dart';

abstract class AlertLocalDataSource {
  List<AlertModel> getAlerts();
}

class AlertLocalDataSourceImpl implements AlertLocalDataSource {
  const AlertLocalDataSourceImpl();

  @override
  List<AlertModel> getAlerts() {
    final now = DateTime.now();
    return [
      AlertModel(
        id: 'alert_001',
        title: 'Flood Warning — Bued River Basin',
        description:
            'Water levels in Bued have risen to critical levels. Residents in low-lying areas should prepare for possible evacuation. Continuous heavy rainfall expected in the next 12 hours.',
        severity: 'High',
        type: 'flood',
        barangayName: 'Bued',
        timestamp: now.subtract(const Duration(minutes: 15)),
        isRead: false,
      ),
      AlertModel(
        id: 'alert_002',
        title: 'Extreme Heat Index — San Felipe Central',
        description:
            'Heat index has reached 42°C. Outdoor activities should be limited. Drink plenty of water and stay in shaded areas. Vulnerable populations should remain indoors.',
        severity: 'High',
        type: 'heat',
        barangayName: 'San Felipe Central',
        timestamp: now.subtract(const Duration(hours: 1)),
        isRead: false,
      ),
      AlertModel(
        id: 'alert_003',
        title: 'Seismic Activity Detected Near Capas',
        description:
            'Minor tremors (magnitude 3.2) detected. No tsunami threat. Residents advised to review earthquake preparedness protocols and identify safe spots.',
        severity: 'Medium',
        type: 'earthquake',
        barangayName: 'Capas',
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      AlertModel(
        id: 'alert_004',
        title: 'Flash Flood Risk — Sumabnit Area',
        description:
            'Soil saturation levels are high after 3 consecutive days of rain. Flash flooding is possible in Sumabnit and adjacent barangays during heavy downpour.',
        severity: 'High',
        type: 'flood',
        barangayName: 'Sumabnit',
        timestamp: now.subtract(const Duration(hours: 3)),
        isRead: true,
      ),
      AlertModel(
        id: 'alert_005',
        title: 'Heat Advisory — San Felipe Sur',
        description:
            'Temperatures are expected to remain above 33°C for the next 48 hours. Ensure adequate hydration and limit strenuous outdoor work between 10AM–3PM.',
        severity: 'Medium',
        type: 'heat',
        barangayName: 'San Felipe Sur',
        timestamp: now.subtract(const Duration(hours: 5)),
        isRead: true,
      ),
      AlertModel(
        id: 'alert_006',
        title: 'Flood Watch Lifted — Mangcasuy',
        description:
            'Water levels have receded to normal. The flood watch for Mangcasuy has been lifted. Continue monitoring weather updates.',
        severity: 'Low',
        type: 'flood',
        barangayName: 'Mangcasuy',
        timestamp: now.subtract(const Duration(hours: 8)),
        isRead: true,
      ),
      AlertModel(
        id: 'alert_007',
        title: 'Earthquake Preparedness Drill — Dumayat',
        description:
            'Scheduled community earthquake drill on June 10 at 9:00 AM. All residents are encouraged to participate. Assembly point: Dumayat Elementary School.',
        severity: 'Low',
        type: 'earthquake',
        barangayName: 'Dumayat',
        timestamp: now.subtract(const Duration(hours: 12)),
        isRead: true,
      ),
      AlertModel(
        id: 'alert_008',
        title: 'Rising Water Levels — Santiago',
        description:
            'Moderate rainfall has caused water levels in Santiago to rise. Situation is being monitored closely. No evacuation required at this time.',
        severity: 'Medium',
        type: 'flood',
        barangayName: 'Santiago',
        timestamp: now.subtract(const Duration(hours: 16)),
        isRead: true,
      ),
      AlertModel(
        id: 'alert_009',
        title: 'Temperature Spike — Capas',
        description:
            'Temperature in Capas has exceeded 33°C, crossing the danger threshold. Elderly and children should avoid prolonged sun exposure.',
        severity: 'Medium',
        type: 'heat',
        barangayName: 'Capas',
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
      AlertModel(
        id: 'alert_010',
        title: 'All Clear — Santa Catalina',
        description:
            'Previous earthquake advisory has been cleared. No aftershocks detected in the last 24 hours. Resume normal activities.',
        severity: 'Low',
        type: 'earthquake',
        barangayName: 'Santa Catalina',
        timestamp: now.subtract(const Duration(days: 1, hours: 6)),
        isRead: true,
      ),
    ];
  }
}
