import 'package:hive/hive.dart';

import '../model/featured_match_model.dart';

const String featuredMatchBox = 'featured_match_box';

Future<void> saveFeaturedMatch(FeaturedMatchModel model) async {
  final box = await Hive.openBox<FeaturedMatchModel>(featuredMatchBox);
  await box.put('live', model);
}

FeaturedMatchModel? getFeaturedMatch() {
  final box = Hive.box<FeaturedMatchModel>(featuredMatchBox);
  return box.get('live');
}
