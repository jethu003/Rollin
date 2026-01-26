

import 'package:rollin_user/data/repositories/booking_repository.dart';

class UploadBookingUseCase {
  final BookingRepository repository;

  UploadBookingUseCase(this.repository);

  Future<String> call({
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
    return await repository.uploadBooking(
      showId: showId,
      theatreId: theatreId,
      movieTitle: movieTitle,
      showTime: showTime,
      lockedSeats: lockedSeats,
      tiers: tiers,
      totalPrice: totalPrice,
      theatreName: theatreName,
      posterUrl: posterUrl,
      showDate: showDate,
    );
  }
}
