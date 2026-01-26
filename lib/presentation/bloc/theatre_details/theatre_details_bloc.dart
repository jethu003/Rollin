// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rollin_user/data/repositories/theatre_detail.dart';
// import 'theatre_details_event.dart';
// import 'theatre_details_state.dart';


// class TheatreDetailsBloc
//     extends Bloc<TheatreDetailsEvent, TheatreDetailsState> {
//   final TheatreRepository repository;

//   TheatreDetailsBloc(this.repository) : super(TheatreLoading()) {
//     on<LoadShows>(_loadShows);
//     on<ChangeDate>(_changeDate);
//   }

//   Future<void> _loadShows(
//       LoadShows event, Emitter emit) async {
//     emit(TheatreLoading());
//     try {
//       final shows = await repository.fetchShows(event.theatreId);
//       emit(TheatreLoaded(
//         shows: shows,
//         selectedDate: DateTime.now(),
//       ));
//     } catch (e) {
//       emit(TheatreError('Failed to load shows'));
//     }
//   }

//   void _changeDate(
//       ChangeDate event, Emitter emit) {
//     if (state is TheatreLoaded) {
//       final current = state as TheatreLoaded;
//       emit(TheatreLoaded(
//         shows: current.shows,
//         selectedDate: event.date,
//       ));
//     }
//   }
// }


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rollin_user/data/repositories/theatre_detail.dart';
import 'theatre_details_event.dart';
import 'theatre_details_state.dart';

class TheatreDetailsBloc
    extends Bloc<TheatreDetailsEvent, TheatreDetailsState> {
  final TheatreRepository theatreRepository;
  final MovieRepository movieRepository;

  TheatreDetailsBloc(
    this.theatreRepository,
    this.movieRepository,
  ) : super(TheatreLoading()) {
    on<LoadShows>(_loadShows);
    on<ChangeDate>(_changeDate);
  }

  Future<void> _loadShows(
      LoadShows event, Emitter<TheatreDetailsState> emit) async {
    emit(TheatreLoading());

    try {
      final shows =
          await theatreRepository.fetchShows(event.theatreId);

      // ✅ Extract unique movieIds from shows
      final movieIds = shows
          .map((e) => e.data()['movieId'])
          .whereType<int>()
          .toSet()
          .toList();

      // ✅ Fetch movie master data
      final movies =
          await movieRepository.fetchMovies(movieIds);

      emit(TheatreLoaded(
        shows: shows,
        movies: movies,
        selectedDate: DateTime.now(),
      ));
    } catch (e) {
      emit(TheatreError('Failed to load shows'));
    }
  }

  void _changeDate(
      ChangeDate event, Emitter<TheatreDetailsState> emit) {
    if (state is TheatreLoaded) {
      final current = state as TheatreLoaded;
      emit(TheatreLoaded(
        shows: current.shows,
        movies: current.movies,
        selectedDate: event.date,
      ));
    }
  }
}

