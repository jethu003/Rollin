import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rollin_user/data/models/show_layout_model.dart';

abstract class ShowRemoteDataSource {
  Future<ShowLayoutModel> fetchShowLayout(String showId);
  Future<void> lockSeats(String showId, List<String> seatIds, int lockDuration);
}

class ShowRemoteDataSourceImpl implements ShowRemoteDataSource {
  final FirebaseFirestore firestore;

  ShowRemoteDataSourceImpl(this.firestore);

  @override
  Future<ShowLayoutModel> fetchShowLayout(String showId) async {
    final doc = await firestore.collection('shows').doc(showId).get();
    if (!doc.exists) throw Exception("Show not found");
    return ShowLayoutModel.fromMap(doc.id, doc.data()!);
  }

  @override
  Future<void> lockSeats(String showId, List<String> seatIds, int lockDuration) async {
    final ref = firestore.collection('shows').doc(showId);
    final now = DateTime.now().millisecondsSinceEpoch;
    final expiry = now + lockDuration;

    final updates = {for (var s in seatIds) 'tempLocks.$s': expiry};
    await ref.update(updates);
  }
}
