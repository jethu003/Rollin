abstract class SeatEvent {}

class StartSeatListening extends SeatEvent {
  final String showId;
  StartSeatListening(this.showId);
}

class SeatTapped extends SeatEvent {
  final String seatId;
  SeatTapped(this.seatId);
}

class LockSelectedSeats extends SeatEvent {
  final String showId;
  LockSelectedSeats(this.showId);
}
