import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rollin_user/presentation/bloc/seat_bloc/seat_bloc_event.dart';
import 'package:rollin_user/presentation/bloc/seat_bloc/seat_bloc_state.dart';


class SeatBloc extends Bloc<SeatEvent, SeatState> {
  final FirebaseFirestore firestore;

  SeatBloc(this.firestore) : super(SeatInitial()) {
    on<UnlockSeatsEvent>(_unlockSeats);
  }

  Future<void> _unlockSeats(
    UnlockSeatsEvent event,
    Emitter<SeatState> emit,
  ) async {
    emit(SeatUnlocking());

    try {
      final ref = firestore
          .collection("shows")
          .doc(event.showId)
          .collection("lockedSeats");

      for (final seat in event.seats) {
        await ref.doc(seat).delete();
      }

      emit(SeatUnlocked());
    } catch (e) {
      emit(SeatUnlockFailed(e.toString()));
    }
  }
}
