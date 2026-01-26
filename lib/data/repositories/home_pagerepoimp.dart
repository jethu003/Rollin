import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:rollin_user/domain/entities/home_page_entity.dart';
import 'package:rollin_user/domain/repositories/home_page_repository.dart';

import '../models/homepage_model.dart';

class MovieRepositoryImpl implements MovieRepository {
  final FirebaseFirestore firestore;

  MovieRepositoryImpl(this.firestore);

  @override
  Future<List<MovieEntity>> getNowPlayingMovies() async {
    final today = DateTime.now();
    final todayString =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    final showSnapshot = await firestore.collectionGroup('shows').get();

    final Set<int> movieIds = {};

    for (var doc in showSnapshot.docs) {
      final data = doc.data();
      final showDate = data['date'];

      if (showDate == null || showDate.compareTo(todayString) < 0) continue;
      if (data['movieId'] != null) movieIds.add(data['movieId']);
    }

    if (movieIds.isEmpty) return [];

    final movieSnapshot = await firestore
        .collection('now_playing')
        .where('id', whereIn: movieIds.toList())
        .get();

    return movieSnapshot.docs
        .map((doc) => MovieModel.fromJson(doc.data()))
        .toList();
  }
}
