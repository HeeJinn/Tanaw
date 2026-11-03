import 'package:shared_preferences/shared_preferences.dart';

/// Read/unread state lives on the device: residents don't sign in.
abstract class AlertLocalDataSource {
  Future<Set<String>> getReadIds();
  Future<void> saveReadIds(Set<String> ids);
}

class AlertLocalDataSourceImpl implements AlertLocalDataSource {
  static const _key = 'read_alert_ids';

  const AlertLocalDataSourceImpl();

  @override
  Future<Set<String>> getReadIds() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key) ?? const []).toSet();
  }

  @override
  Future<void> saveReadIds(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, ids.toList());
  }
}
