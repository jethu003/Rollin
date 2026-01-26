import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rollin_user/data/repositories/seat_management_repository.dart';

import 'seat_management_event.dart';
import 'seat_management_state.dart';


class SeatBloc extends Bloc<SeatEvent, SeatState> {
  final SeatRepository repository;
  StreamSubscription? _sub;

  SeatBloc(this.repository) : super(SeatLoading()) {
    on<StartSeatListening>(_onStartListening);
    on<SeatTapped>(_onSeatTapped);
    on<LockSelectedSeats>(_onLockSeats);
  }

  void _onStartListening(
    StartSeatListening event,
    Emitter<SeatState> emit,
  ) {
    emit(SeatLoading());

    _sub?.cancel();
    _sub = repository.listenShow(event.showId).listen((snapshot) {
      final data = snapshot.data();
      if (data == null) return;

      final now = DateTime.now().millisecondsSinceEpoch;

      final rawLocks = Map<String, dynamic>.from(data['tempLocks'] ?? {});
      final Map<String, int> locks = {};
      rawLocks.forEach((k, v) {
        if (v is int) locks[k] = v;
        if (v is num) locks[k] = v.toInt();
      });

      // Remove expired locks
      locks.removeWhere((_, expiry) => expiry < now);

      final booked = Map<String, dynamic>.from(data['bookedSeats'] ?? {}).keys.toSet();

      emit(SeatLoaded(
        layoutData: Map<String, dynamic>.from(data['layout'] ?? {}),
        tiers: List<Map<String, dynamic>>.from(data['tiers'] ?? []),
        permanentSeats: booked,
        tempLocks: locks,
        selectedSeats: {},
      ));
    });
  }

  void _onSeatTapped(SeatTapped event, Emitter<SeatState> emit) {
    final current = state;
    if (current is! SeatLoaded) return;

    if (current.permanentSeats.contains(event.seatId) ||
        current.tempLocks.containsKey(event.seatId)) {
      return;
    }

    final selected = Set<String>.from(current.selectedSeats);

    if (selected.contains(event.seatId)) {
      selected.remove(event.seatId);
    } else {
      if (selected.length >= 5) {
        emit(SeatLimitReached());
        emit(current);
        return;
      }
      selected.add(event.seatId);
    }

    emit(current.copyWith(selectedSeats: selected));
  }

  Future<void> _onLockSeats(
    LockSelectedSeats event,
    Emitter<SeatState> emit,
  ) async {
    final current = state;
    if (current is! SeatLoaded || current.selectedSeats.isEmpty) return;

    await repository.lockSeats(
      event.showId,
      current.selectedSeats.toList(),
    );

    emit(SeatLockSuccess());
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
