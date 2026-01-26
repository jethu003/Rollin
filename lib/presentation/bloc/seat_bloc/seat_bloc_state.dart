abstract class SeatState {}

class SeatInitial extends SeatState {}

class SeatUnlocking extends SeatState {}

class SeatUnlocked extends SeatState {}

class SeatUnlockFailed extends SeatState {
  final String message;
  SeatUnlockFailed(this.message);
}
