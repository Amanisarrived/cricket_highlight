import 'package:shared_preferences/shared_preferences.dart';

class AppVisitService {
  static const _key = "app_visit_count";

  static Future<int> incrementAndGet() async {
    final prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt(_key) ?? 0;
    count++;
    await prefs.setInt(_key, count);
    return count;
  }
}
