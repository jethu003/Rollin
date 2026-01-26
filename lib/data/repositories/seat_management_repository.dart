import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class SeatRepository {
  final FirebaseFirestore firestore;
  static const int lockDuration = 5 * 60 * 1000;

  SeatRepository(this.firestore);

  Stream<DocumentSnapshot<Map<String, dynamic>>> listenShow(String showId) {
    return firestore.collection('shows').doc(showId).snapshots();
  }

  Future<void> lockSeats(String showId, List<String> seats) async {
    final ref = firestore.collection('shows').doc(showId);
    final expiry = DateTime.now().millisecondsSinceEpoch + lockDuration;

    final updates = <String, dynamic>{};
    for (final seat in seats) {
      updates['tempLocks.$seat'] = expiry;
    }

    await ref.update(updates);
  }
}
