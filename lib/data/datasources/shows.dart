import 'package:cloud_firestore/cloud_firestore.dart';

class Shows {


Future<List<Map<String, dynamic>>> getShowsWithMovieDetails(String theatreId) async {
  final showsQuery = await FirebaseFirestore.instance
      .collection('shows')
      .where('theatreId', isEqualTo: theatreId)
      .get();

  List<Map<String, dynamic>> result = [];

  for (var showDoc in showsQuery.docs) {
    final showData = showDoc.data();
    final movieId = showData['movieId'];

    // Fetch movie details
    final movieDoc = await FirebaseFirestore.instance
        .collection('now_playing')
        .doc(movieId)
        .get();

    final movieData = movieDoc.data();

    // Combine show and movie info
    result.add({
      'show': showData,
      'movie': movieData,
    });
  }
  print(result);
  return result;
}

}