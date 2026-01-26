abstract class BookingState {}
class BookingInitial extends BookingState {}
class BookingLoading extends BookingState {}
class BookingSuccess extends BookingState {
  final String bookingId;
  BookingSuccess(this.bookingId);
}
class BookingFailure extends BookingState {
  final String message;
  BookingFailure(this.message);
}
