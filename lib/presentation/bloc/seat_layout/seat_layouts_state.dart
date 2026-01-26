import 'package:equatable/equatable.dart';
import 'package:rollin_user/domain/entities/seat_entity.dart';



abstract class SeatLayoutState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SeatLayoutInitial extends SeatLayoutState {}
class SeatLayoutLoading extends SeatLayoutState {}
class SeatLayoutLoaded extends SeatLayoutState {
  final ShowLayout showLayout;
  final Set<String> selectedSeats;

  SeatLayoutLoaded({required this.showLayout, this.selectedSeats = const {}});
  @override
  List<Object?> get props => [showLayout, selectedSeats];
}
class SeatLayoutError extends SeatLayoutState {
  final String message;
  SeatLayoutError(this.message);
  @override
  List<Object?> get props => [message];
}
