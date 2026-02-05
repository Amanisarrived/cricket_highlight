import 'package:hive/hive.dart';
import 'package:in_app_review/in_app_review.dart';

class ReviewHelper {
  static final _box = Hive.box('review_box');
  static final InAppReview _inAppReview = InAppReview.instance;

  static Future<void> onShortCompleted() async {
    int count = _box.get('shortsWatchCount', defaultValue: 0) + 1;
    _box.put('shortsWatchCount', count);

    bool hasReviewed = _box.get('hasReviewed', defaultValue: false);
    int? lastTime = _box.get('lastReviewTime');

    bool is3rdShort = count % 3 == 0;

    bool is7DaysPassed = lastTime == null ||
        DateTime.now()
            .difference(DateTime.fromMillisecondsSinceEpoch(lastTime))
            .inDays >=
            7;

    if (!hasReviewed && is3rdShort && is7DaysPassed) {
      await _showReview();
    }
  }

  static Future<void> _showReview() async {
    if (await _inAppReview.isAvailable()) {
      await _inAppReview.requestReview();
      _box.put(
        'lastReviewTime',
        DateTime.now().millisecondsSinceEpoch,
      );
    }
  }
}
