


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rollin_user/domain/usecases/seat_usecase.dart';
import 'package:rollin_user/presentation/bloc/seat_layout/seat_layouts_event.dart';
import 'package:rollin_user/presentation/bloc/seat_layout/seat_layouts_state.dart';

class SeatLayoutBloc extends Bloc<SeatLayoutEvent, SeatLayoutState> {
  final GetShowLayout getShowLayout;
  final LockSeats lockSeats;
  static const int lockDuration = 5 * 60 * 1000; // 5 minutes

  final Set<String> _selectedSeats = {};

  SeatLayoutBloc({required this.getShowLayout, required this.lockSeats}) : super(SeatLayoutInitial()) {
    on<LoadShowLayout>((event, emit) async {
      emit(SeatLayoutLoading());
      try {
        final layout = await getShowLayout(event.showId);
        emit(SeatLayoutLoaded(showLayout: layout, selectedSeats: {}));
      } catch (e) {
        emit(SeatLayoutError(e.toString()));
      }
    });

    on<SelectSeat>((event, emit) {
      if (_selectedSeats.contains(event.seatId)) {
        _selectedSeats.remove(event.seatId);
      } else {
        if (_selectedSeats.length >= 5) return; // max 5
        _selectedSeats.add(event.seatId);
      }
      if (state is SeatLayoutLoaded) {
        emit(SeatLayoutLoaded(
            showLayout: (state as SeatLayoutLoaded).showLayout,
            selectedSeats: Set.from(_selectedSeats)));
      }
    });

    on<LockSelectedSeats>((event, emit) async {
      if (state is SeatLayoutLoaded && _selectedSeats.isNotEmpty) {
        final showId = (state as SeatLayoutLoaded).showLayout.tiers.first.name; // pass showId from UI
        await lockSeats(showId, _selectedSeats.toList(), lockDuration);
      }
    });
  }
}
