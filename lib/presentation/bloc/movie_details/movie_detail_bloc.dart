
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rollin_user/presentation/bloc/movie_details/movie_detail_event.dart';
import 'package:rollin_user/presentation/bloc/movie_details/movie_detail_state.dart';

class MovieDetailsBloc
    extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final FirebaseFirestore firestore;

  MovieDetailsBloc(this.firestore) : super(MovieDetailsInitial()) {
    on<LoadTheatresForMovie>(_loadTheatres);
  }

  Future<void> _loadTheatres(
    LoadTheatresForMovie event,
    Emitter<MovieDetailsState> emit,
  ) async {
    emit(MovieDetailsLoading());

    try {
      final showsSnapshot = await firestore
          .collection('shows')
          .where('movieId', isEqualTo: event.movieId)
          .get();

      List<Map<String, dynamic>> theatres = [];

      for (var showDoc in showsSnapshot.docs) {
        final theatreId = showDoc['theatreId'];

        final theatreSnap =
            await firestore.collection('userprofile').doc(theatreId).get();

        if (theatreSnap.exists) {
          theatres.add({
            "theatreId": theatreId,
            "theatreName": theatreSnap['name'],
            "location": theatreSnap['location'],
            "image": theatreSnap['images'][0],
          });
        }
      }

      emit(MovieDetailsLoaded(theatres));
    } catch (e) {
      emit(MovieDetailsError("Failed to load theatres"));
    }
  }
}
