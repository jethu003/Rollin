import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rollin_user/domain/usecases/home_page_usecase.dart';
import 'package:rollin_user/presentation/bloc/seat_layout/home_page_event.dart';
import 'package:rollin_user/presentation/bloc/seat_layout/home_page_state.dart';



class TheatreMoviesBloc
    extends Bloc<TheatreMoviesEvent, TheatreMoviesState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  TheatreMoviesBloc(this.getNowPlayingMovies)
      : super(TheatreMoviesLoading()) {
    on<LoadTheatreMovies>(_onLoadMovies);
  }

  Future<void> _onLoadMovies(
    LoadTheatreMovies event,
    Emitter<TheatreMoviesState> emit,
  ) async {
    emit(TheatreMoviesLoading());

    try {
      final movies = await getNowPlayingMovies();

      if (movies.isEmpty) {
        emit(const TheatreMoviesError("No movies available"));
      } else {
        emit(TheatreMoviesLoaded(movies));
      }
    } catch (e) {
      emit(const TheatreMoviesError("Failed to load movies"));
    }
  }
}
