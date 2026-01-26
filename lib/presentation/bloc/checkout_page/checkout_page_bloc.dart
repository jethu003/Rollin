import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rollin_user/presentation/bloc/checkout_page/checkout_page_event.dart';
import 'package:rollin_user/presentation/bloc/checkout_page/checkout_page_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final FirebaseFirestore firestore;
  final String showId;
  final String theatreId;

  CheckoutBloc({
    required this.firestore,
    required this.showId,
    required this.theatreId,
  }) : super(const CheckoutState()) {
    on<LoadCheckout>(_loadCheckout);
    on<UnlockSeats>(_unlockSeats);
    on<BookSeats>(_bookSeats);
  }

  Future<void> _loadCheckout(
    LoadCheckout event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final showDoc =
          await firestore.collection('shows').doc(showId).get();
      final theatreDoc =
          await firestore.collection('userprofile').doc(theatreId).get();

      final showData = showDoc.data() ?? {};
      final tempLocks =
          Map<String, dynamic>.from(showData['tempLocks'] ?? {});

      emit(state.copyWith(
        lockedSeats: tempLocks.keys.toList(),
        posterUrl: showData['posterUrl'],
        showDate: showData['displayDate'],
        theatreName: theatreDoc.data()?['name'],
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _unlockSeats(
    UnlockSeats event,
    Emitter<CheckoutState> emit,
  ) async {
    if (state.lockedSeats.isEmpty) return;

    final ref = firestore.collection('shows').doc(showId);

    await firestore.runTransaction((transaction) async {
      final snap = await transaction.get(ref);
      final data = snap.data() ?? {};
      final tempLocks =
          Map<String, dynamic>.from(data['tempLocks'] ?? {});

      for (var seat in state.lockedSeats) {
        tempLocks.remove(seat);
      }

      transaction.update(ref, {'tempLocks': tempLocks});
    });
  }

  Future<void> _bookSeats(
    BookSeats event,
    Emitter<CheckoutState> emit,
  ) async {
    if (state.lockedSeats.isEmpty) return;

    final ref = firestore.collection('shows').doc(showId);

    await firestore.runTransaction((transaction) async {
      final snap = await transaction.get(ref);
      final data = snap.data() ?? {};

      final bookedSeats =
          Map<String, dynamic>.from(data['bookedSeats'] ?? {});
      final tempLocks =
          Map<String, dynamic>.from(data['tempLocks'] ?? {});

      for (var seat in state.lockedSeats) {
        bookedSeats[seat] = true;
        tempLocks.remove(seat);
      }

      transaction.update(ref, {
        'bookedSeats': bookedSeats,
        'tempLocks': tempLocks,
      });
    });
  }
}
