class BookingEntity {
  final String bookingId;
  final List<String> seats;
  final String theatreName;
  final String theatreId;
  final String movieTitle;
  final String showTime;
  final String showDate;
  final String posterUrl;
  final DateTime createdAt;

  BookingEntity({
    required this.bookingId,
    required this.seats,
    required this.theatreName,
    required this.theatreId,
    required this.movieTitle,
    required this.showTime,
    required this.showDate,
    required this.posterUrl,
    required this.createdAt,
  });
}
