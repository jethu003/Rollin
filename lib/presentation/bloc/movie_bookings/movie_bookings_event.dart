// Events
abstract class BookingEvent {}

class FetchUserBookings extends BookingEvent {
  final String userId;
  FetchUserBookings(this.userId);
}
