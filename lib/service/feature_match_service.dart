import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricket_highlight/model/featured_match_model.dart';
import 'package:cricket_highlight/service/hive_feature_match_service.dart';

class FeatureMatchService {
  final _firestore = FirebaseFirestore.instance;
  final _collection = 'featured_match';

  // 🔥 PURE REALTIME STREAM
  Stream<FeaturedMatchModel?> streamFeaturedMatch() {
    return _firestore
        .collection(_collection)
        .doc('current')
        .snapshots()
        .map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return FeaturedMatchModel.fromMap(doc.data()!);
    });
  }

  // ❄️ OFFLINE / COLD START
  Future<FeaturedMatchModel?> getCachedMatch() async {
    return getFeaturedMatch();
  }

  // MANUALLY call when needed (not inside stream)
  Future<void> cacheMatch(FeaturedMatchModel model) async {
    await saveFeaturedMatch(model);
  }
}
