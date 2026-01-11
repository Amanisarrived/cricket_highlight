import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class AnalyticsObserver {
  static final FirebaseAnalytics analytics =
      FirebaseAnalytics.instance;

  static final FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);
}
