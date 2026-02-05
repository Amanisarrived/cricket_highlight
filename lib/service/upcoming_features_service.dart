import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/upcoming_fixture_model.dart';

class UpcomingFixtureService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<UpcomingFixtureModel>> streamUpcomingFixtures() {
    return _firestore
        .collection('upcoming_fixtures')
        .orderBy('time', descending: false) // 🔥 sabse important line
        .limit(3) // sirf next 3 matches
        .snapshots()
        .map((snapshot) {
      print("DOC COUNT: ${snapshot.docs.length}");

      return snapshot.docs
          .map((doc) => UpcomingFixtureModel.fromDoc(doc))
          .toList();
    });
  }
}
