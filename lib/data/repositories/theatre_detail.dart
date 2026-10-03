import 'package:cloud_firestore/cloud_firestore.dart';



class TheatreRepository {
  final FirebaseFirestore firestore;

  TheatreRepository(this.firestore);

  /// Convert show date + time to DateTime
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

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchShows(
      String theatreId) async {
    final now = DateTime.now();

    
    final snap = await firestore
        .collection('shows')
        .where('theatreId', isEqualTo: theatreId)
        .get();

    /// 2️ Filter only upcoming shows
    final validShows = snap.docs.where((doc) {
      final data = doc.data();

      final date = data['date'];
      final time = data['time'];

      if (date == null || time == null) return false;

      final showDateTime = _parseShowDateTime(date, time);

      ///  Skip past shows
      return !showDateTime.isBefore(now);
    }).toList();

    return validShows;
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
        int.parse(doc.id): doc.data(), //doc.id is movieId
    };
  }
}



