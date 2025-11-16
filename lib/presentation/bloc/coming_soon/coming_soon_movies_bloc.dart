import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rollin_user/domain/usecases/coming_soon_usecase.dart';
import 'package:rollin_user/presentation/bloc/coming_soon/coming_soon_movies_event.dart';
import 'package:rollin_user/presentation/bloc/coming_soon/coming_soon_movies_state.dart';


class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetComingSoonMovies getComingSoonMovies;

  MovieBloc(this.getComingSoonMovies) : super(MovieInitial()) {
    on<FetchComingSoonMovies>((event, emit) async {
      emit(MovieLoading());
      try {
        final movies = await getComingSoonMovies();
        emit(MovieSuccess(movies));
      } catch (e) {
        emit(MovieFailure(e.toString()));
      }
    });
  }
}
