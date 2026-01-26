import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rollin_user/data/models/booking_model.dart';


class BookingDataSource {
  final FirebaseFirestore firestore;

  BookingDataSource(this.firestore);

  Future<List<BookingModel>> getUserBookings(String userId) async {
    try {
      final bookingsSnapshot = await firestore
          .collection('rollin_user_bookings')
          .doc(userId)
          .collection('bookings')
          .orderBy('createdAt', descending: true)
          .get();

      return bookingsSnapshot.docs
          .map((doc) => BookingModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error fetching bookings: $e');
    }
  }
}
