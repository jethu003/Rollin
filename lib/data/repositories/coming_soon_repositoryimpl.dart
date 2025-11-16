import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rollin_user/domain/entities/coming_soon.dart';
import 'package:rollin_user/domain/repositories/coming_soon_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final FirebaseFirestore firestore;

  MovieRepositoryImpl(this.firestore);

  @override
  Future<List<MovieEntity>> getComingSoonMovies() async {
    final snapshot = await firestore.collection('coming_soon').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return MovieEntity(
        id: doc.id,
        title: data['title'] ?? '',
        backdropUrl: data['backdropUrl'] ?? '',
        posterUrl: data['posterUrl'] ?? '',
        language: data['language'] ?? '',
        overview: data['overview'] ?? '',
        rating: data['rating'] != null ? (data['rating'] as num).toDouble() : 0.0,
        releaseDate: data['release_date'] ?? '',
        trailerUrl: data['trailerUrl'] ?? '',
        genres: data['genres'] != null ? List<String>.from(data['genres']) : [],
        cast: data['cast'] != null
            ? (data['cast'] as List).map((c) => CastEntity(
                  name: c['name'] ?? '',
                  character: c['character'] ?? '',
                  profileUrl: c['profileUrl'] ?? '',
                )).toList()
            : [],
        crew: data['crew'] != null
            ? (data['crew'] as List).map((c) => CrewEntity(
                  name: c['name'] ?? '',
                  job: c['job'] ?? '',
                )).toList()
            : [],
      );
    }).toList();
  }
}
