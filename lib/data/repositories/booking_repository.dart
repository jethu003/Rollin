
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BookingRepository {
  Future<String> uploadBooking({
    required String showId,
    required String theatreId,
    required String movieTitle,
    required String showTime,
    required List<String> lockedSeats,
    required List<String> tiers,
    required double totalPrice,
    String? theatreName,
    String? posterUrl,
    String? showDate,
  });
}

class BookingRepositoryImpl implements BookingRepository {
  final FirebaseFirestore firestore;

  BookingRepositoryImpl(this.firestore);

  @override
  Future<String> uploadBooking({
    required String showId,
    required String theatreId,
    required String movieTitle,
    required String showTime,
    required List<String> lockedSeats,
    required List<String> tiers,
    required double totalPrice,
    String? theatreName,
    String? posterUrl,
    String? showDate,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    final collectionRef = firestore
        .collection("rollin_user_bookings")
        .doc(user.uid)
        .collection("bookings");

    final bookingId = collectionRef.doc().id;

    final bookingData = {
      "bookingId": bookingId,
      "userId": user.uid,
      "showId": showId,
      "theatreId": theatreId,
      "theatreName": theatreName,
      "movieTitle": movieTitle,
      "posterUrl": posterUrl,
      "screenName": null,
      "date": showDate,
      "time": showTime,
      "seats": lockedSeats,
      "tiers": tiers,
      "totalPrice": totalPrice,
      "createdAt": FieldValue.serverTimestamp(),
    };

    // fetch screenName from shows/{showId}
    final showDoc = await firestore.collection("shows").doc(showId).get();
    if (showDoc.exists) {
      bookingData["screenName"] = showDoc.data()?["screenName"] ?? "";
    }

    await collectionRef.doc(bookingId).set(bookingData);

    return bookingId;
  }
}
