import 'package:cloud_firestore/cloud_firestore.dart';

class TheatreRepository {
  final FirebaseFirestore firestore;

  TheatreRepository(this.firestore);

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchShows(
      String theatreId) async {
    final snap = await firestore
        .collection('shows')
        .where('theatreId', isEqualTo: theatreId)
        .get();

    return snap.docs;
  }
}



class MovieRepository {
  final FirebaseFirestore firestore;

  MovieRepository(this.firestore);

  Future<Map<int, Map<String, dynamic>>> fetchMovies(
      List<int> movieIds) async {
    if (movieIds.isEmpty) return {};

  
    final idsAsString = movieIds.map((e) => e.toString()).toList();

    final snap = await firestore
        .collection('now_playing')
        .where(FieldPath.documentId, whereIn: idsAsString)
        .get();

    return {
      for (var doc in snap.docs)
        int.parse(doc.id): doc.data(), // 👈 doc.id is movieId
    };
  }
}
