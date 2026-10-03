
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String bookingId;
  final String movieTitle;
  final String posterUrl;
  final String screenName;
  final List<String> seats;
  final String showId;
  final String theatreId;
  final String theatreName;
  final List<String> tiers;
  final String date;
  final String time;
  final double totalPrice;
  final String userId;
  final DateTime createdAt;

  BookingModel({
    required this.bookingId,
    required this.movieTitle,
    required this.posterUrl,
    required this.screenName,
    required this.seats,
    required this.showId,
    required this.theatreId,
    required this.theatreName,
    required this.tiers,
    required this.date,
    required this.time,
    required this.totalPrice,
    required this.userId,
    required this.createdAt,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      bookingId: map['bookingId'] ?? '',
      movieTitle: map['movieTitle'] ?? '',
      posterUrl: map['posterUrl'] ?? '',
      screenName: map['screenName']?.toString().trim() ?? '',
      seats: List<String>.from(map['seats'] ?? []),
      showId: map['showId'] ?? '',
      theatreId: map['theatreId'] ?? '',
      theatreName: map['theatreName'] ?? '',
      tiers: List<String>.from(map['tiers'] ?? []),
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
      userId: map['userId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
