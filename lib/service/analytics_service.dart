import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics =
      FirebaseAnalytics.instance;

  static FirebaseAnalytics get analytics => _analytics;

  /// Screen tracking (manual if needed)
  static Future<void> logScreen(String screenName) async {
    await _analytics.logScreenView(
      screenName: screenName,
    );
  }

  /// Custom events
  static Future<void> logEvent(
      String name, {
        Map<String, Object>? params,
      }) async {
    await _analytics.logEvent(
      name: name,
      parameters: params,
    );
  }
}
