

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rollin_user/data/models/movie_model.dart';
import 'package:rollin_user/data/models/show_model.dart';
import 'package:rollin_user/data/models/theatre_model.dart';

class FirestoreDataSource {
  final FirebaseFirestore firestore;

  FirestoreDataSource(this.firestore);

  ///  Convert Firestore date + time to DateTime
  DateTime _parseShowDateTime(String date, String time) {


    final dateParts = date.split('-');
    final year = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final day = int.parse(dateParts[2]);

    final timeParts = time.split(' ');
    final hourMinute = timeParts[0].split(':');

    int hour = int.parse(hourMinute[0]);
    final minute = int.parse(hourMinute[1]);
    final isPM = timeParts[1].toUpperCase() == 'PM';

    if (isPM && hour != 12) hour += 12;
    if (!isPM && hour == 12) hour = 0;

    return DateTime(year, month, day, hour, minute);
  }


  Future<List<Map<String, dynamic>>> getShowsWithDetails() async {
    try {
      final showsSnapshot = await firestore.collection('shows').get();

      final List<Map<String, dynamic>> result = [];

     
      final Map<String, TheatreModel> theatreCache = {};
      final Map<int, MovieModel> movieCache = {};

      final DateTime now = DateTime.now();

      for (final doc in showsSnapshot.docs) {
        final showData = ShowModel.fromMap(doc.data(), doc.id);

        
        if (showData.status != 'active') continue;

        
        final showDateTime =
            _parseShowDateTime(showData.date, showData.time);

        if (showDateTime.isBefore(now)) {
          continue;
        }

        //  Theatre
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

        //  Movie
        MovieModel? movieData;
        if (movieCache.containsKey(showData.movieId)) {
          movieData = movieCache[showData.movieId];
        } else {
          final movieQuery = await firestore
              .collection('now_playing')
              .where('id', isEqualTo: showData.movieId)
              .limit(1)
              .get();

          if (movieQuery.docs.isEmpty) continue;

          movieData =
              MovieModel.fromMap(movieQuery.docs.first.data());

          movieCache[showData.movieId] = movieData;
        }

        //  Add valid show
        result.add({
          'show': showData,
          'theatre': theatreData!,
          'movie': movieData!,
        });
      }

      return result;
    } catch (e) {
      print('Error fetching shows: $e');
      rethrow;
    }
  }
}

