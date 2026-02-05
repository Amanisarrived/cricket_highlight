import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/featured_match_model.dart';
import '../service/feature_match_service.dart';

class FeaturedMatchRepository {
  final _service = FeatureMatchService();

  Stream<FeaturedMatchModel?> watchLiveMatch() {
    return _service.streamFeaturedMatch();
  }

  Future<FeaturedMatchModel?> getOfflineMatch() {
    return _service.getCachedMatch();
  }


  Future<void> resetLastBallsIfOverComplete(
      FeaturedMatchModel match) async {


    const extraBalls = ["WD", "NB", "B", "LB"];


    final legalBallCount = match.lastBalls
        .where((ball) => !extraBalls.contains(ball))
        .length;


    if (legalBallCount >= 6) {
      await FirebaseFirestore.instance
          .collection('featured_match')
          .doc('current')
          .update({
        'lastballs': [],
      });
    }
  }
}
