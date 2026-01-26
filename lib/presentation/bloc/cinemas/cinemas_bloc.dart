// presentation/bloc/cinema/cinema_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rollin_user/domain/usecases/cinemas_usecase.dart';
import 'package:rollin_user/presentation/bloc/cinemas/cinemas_event.dart';
import 'package:rollin_user/presentation/bloc/cinemas/cinemas_state.dart';

class CinemaBloc extends Bloc<CinemaEvent, CinemaState> {
  final GetCinemas getCinemas;

  CinemaBloc(this.getCinemas) : super(CinemaLoading()) {
    on<LoadCinemas>((event, emit) async {
      emit(CinemaLoading());
      try {
        final cinemas = await getCinemas();
        emit(CinemaLoaded(cinemas));
      } catch (e) {
        emit(CinemaError('Failed to load cinemas'));
      }
    });
  }
}
