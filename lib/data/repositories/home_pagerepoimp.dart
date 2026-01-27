
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:rollin_user/domain/entities/home_page_entity.dart';
import 'package:rollin_user/domain/repositories/home_page_repository.dart';
import '../models/homepage_model.dart';

class MovieRepositoryImpl implements MovieRepository {
  final FirebaseFirestore firestore;

  MovieRepositoryImpl(this.firestore);


  DateTime _parseShowDateTime(String date, String time) {
    // date: yyyy-MM-dd
    final dateParts = date.split('-');
    final year = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final day = int.parse(dateParts[2]);

    // time: hh:mm AM/PM
    final timeParts = time.split(' ');
    final hourMinute = timeParts[0].split(':');
    int hour = int.parse(hourMinute[0]);
    final minute = int.parse(hourMinute[1]);
    final isPM = timeParts[1].toUpperCase() == 'PM';

    if (isPM && hour != 12) hour += 12;
    if (!isPM && hour == 12) hour = 0;

    return DateTime(year, month, day, hour, minute);
  }

  @override
  Future<List<MovieEntity>> getNowPlayingMovies() async {
    final now = DateTime.now();

    /// 1️Fetch all shows
    final showSnapshot =
        await firestore.collectionGroup('shows').get();

    final Set<int> movieIds = {};

    /// 2️ Filter valid future shows
    for (final doc in showSnapshot.docs) {
      final data = doc.data();

      final date = data['date'];
      final time = data['time'];
      final movieId = data['movieId'];

      if (date == null || time == null || movieId == null) continue;

      final showDateTime = _parseShowDateTime(date, time);

      /// Ignore past shows
      if (showDateTime.isBefore(now)) continue;

      movieIds.add(movieId);
    }

    if (movieIds.isEmpty) return [];

    /// 3Fetch movies that have valid future shows
    final movieSnapshot = await firestore
        .collection('now_playing')
        .where('id', whereIn: movieIds.toList())
        .get();

    /// 4 Convert to entities
    return movieSnapshot.docs
        .map((doc) => MovieModel.fromJson(doc.data()))
        .toList();
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:rollin_user/domain/entities/home_page_entity.dart';
// import 'package:rollin_user/domain/repositories/home_page_repository.dart';

// import '../models/homepage_model.dart';

// class MovieRepositoryImpl implements MovieRepository {
//   final FirebaseFirestore firestore;

//   MovieRepositoryImpl(this.firestore);

//   @override
//   Future<List<MovieEntity>> getNowPlayingMovies() async {
//     final today = DateTime.now();
//     final todayString =
//         "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

//     final showSnapshot = await firestore.collectionGroup('shows').get();

//     final Set<int> movieIds = {};

//     for (var doc in showSnapshot.docs) {
//       final data = doc.data();
//       final showDate = data['date'];

//       if (showDate == null || showDate.compareTo(todayString) < 0) continue;
//       if (data['movieId'] != null) movieIds.add(data['movieId']);
//     }

//     if (movieIds.isEmpty) return [];

//     final movieSnapshot = await firestore
//         .collection('now_playing')
//         .where('id', whereIn: movieIds.toList())
//         .get();

//     return movieSnapshot.docs
//         .map((doc) => MovieModel.fromJson(doc.data()))
//         .toList();
//   }
// }
