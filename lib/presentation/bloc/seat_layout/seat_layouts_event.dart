import 'package:equatable/equatable.dart';

abstract class SeatLayoutEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadShowLayout extends SeatLayoutEvent {
  final String showId;
  LoadShowLayout(this.showId);
  @override
  List<Object?> get props => [showId];
}

class SelectSeat extends SeatLayoutEvent {
  final String seatId;
  SelectSeat(this.seatId);
  @override
  List<Object?> get props => [seatId];
}

class LockSelectedSeats extends SeatLayoutEvent {}
