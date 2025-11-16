import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rollin_user/data/models/movie_model.dart';
import 'package:rollin_user/data/models/show_model.dart';
import 'package:rollin_user/data/models/theatre_model.dart';

class FirestoreDataSource {
  final FirebaseFirestore firestore;

  FirestoreDataSource(this.firestore);

  Future<List<Map<String, dynamic>>> getShowsWithDetails() async {
    try {
      final showsSnapshot = await firestore.collection('shows').get();
      List<Map<String, dynamic>> result = [];

      // 🧠 Local caches to avoid duplicate Firestore calls
      final Map<String, TheatreModel> theatreCache = {};
      final Map<int, MovieModel> movieCache = {};

      for (var doc in showsSnapshot.docs) {
        final showData = ShowModel.fromMap(doc.data(), doc.id);

        // 🎭 Fetch theatre (use cache if already fetched)
        TheatreModel? theatreData;
        if (theatreCache.containsKey(showData.theatreId)) {
          theatreData = theatreCache[showData.theatreId];
        } else {
          final theatreDoc = await firestore
              .collection('userprofile')
              .doc(showData.theatreId)
              .get();

          if (!theatreDoc.exists) continue;

          theatreData =
              TheatreModel.fromMap(theatreDoc.data()!, theatreDoc.id);
          theatreCache[showData.theatreId] = theatreData;
        }

        // 🎬 Fetch movie (use cache if already fetched)
        MovieModel? movieData;
        if (movieCache.containsKey(showData.movieId)) {
          movieData = movieCache[showData.movieId];
        } else {
          final movieQuery = await firestore
              .collection('now_playing')
              .where('id', isEqualTo: showData.movieId)
              .get();

          if (movieQuery.docs.isEmpty) continue;

          movieData = MovieModel.fromMap(movieQuery.docs.first.data());
          movieCache[showData.movieId] = movieData;
        }

        // 🧾 Add combined data
        result.add({
          'show': showData,
          'theatre': theatreData!,
          'movie': movieData!,
        });
      }

      return result;
    } catch (e) {
      print( e);
      
      rethrow;
    }
  }
}
