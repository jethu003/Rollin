// presentation/bloc/booking/booking_bloc.dart


abstract class BookingEvent {}
class UploadBookingEvent extends BookingEvent {
  final String showId;
  final String theatreId;
  final String movieTitle;
  final String showTime;
  final List<String> lockedSeats;
  final List<String> tiers;
  final double totalPrice;
  final String? theatreName;
  final String? posterUrl;
  final String? showDate;

  UploadBookingEvent({
    required this.showId,
    required this.theatreId,
    required this.movieTitle,
    required this.showTime,
    required this.lockedSeats,
    required this.tiers,
    required this.totalPrice,
    this.theatreName,
    this.posterUrl,
    this.showDate,
  });
}


