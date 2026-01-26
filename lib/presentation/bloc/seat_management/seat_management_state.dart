abstract class SeatState {}

class SeatLoading extends SeatState {}

class SeatLoaded extends SeatState {
  final Map<String, dynamic> layoutData;
  final List<Map<String, dynamic>> tiers;
  final Set<String> permanentSeats;
  final Map<String, int> tempLocks;
  final Set<String> selectedSeats;

  SeatLoaded({
    required this.layoutData,
    required this.tiers,
    required this.permanentSeats,
    required this.tempLocks,
    required this.selectedSeats,
  });

  SeatLoaded copyWith({
    Set<String>? selectedSeats,
    Set<String>? permanentSeats,
    Map<String, int>? tempLocks,
  }) {
    return SeatLoaded(
      layoutData: layoutData,
      tiers: tiers,
      permanentSeats: permanentSeats ?? this.permanentSeats,
      tempLocks: tempLocks ?? this.tempLocks,
      selectedSeats: selectedSeats ?? this.selectedSeats,
    );
  }
}

class SeatLimitReached extends SeatState {}

/// 🔥 CRITICAL
class SeatLockSuccess extends SeatState {}
