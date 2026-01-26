abstract class SeatEvent {}

class UnlockSeatsEvent extends SeatEvent {
  final String showId;
  final List<String> seats;
  UnlockSeatsEvent(this.showId, this.seats);
}
