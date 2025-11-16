class ShowModel {
  final String id;
  final String theatreId;
  final int movieId;
  final String time;
  final String date;
  final String screenName;
  final String status;

  ShowModel({
    required this.id,
    required this.theatreId,
    required this.movieId,
    required this.time,
    required this.date,
    required this.screenName,
    required this.status,
  });

  /// 🧩 Create from Firestore or API Map
  factory ShowModel.fromMap(Map<String, dynamic> map, String id) {
    return ShowModel(
      id: id,
      theatreId: map['theatreId'] ?? '',
      movieId: map['movieId'] is int
          ? map['movieId']
          : int.tryParse(map['movieId'].toString()) ?? 0,
      time: map['time'] ?? '',
      date: map['date'] ?? '',
      screenName: map['screenName'] ?? '',
      status: map['status'] ?? '',
    );
  }

  /// 🔁 Convert to JSON / Map (for debug, Firestore, or network calls)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'theatreId': theatreId,
      'movieId': movieId,
      'time': time,
      'date': date,
      'screenName': screenName,
      'status': status,
    };
  }

  /// ✨ Optional: modify values easily without rebuilding from scratch
  ShowModel copyWith({
    String? id,
    String? theatreId,
    int? movieId,
    String? time,
    String? date,
    String? screenName,
    String? status,
  }) {
    return ShowModel(
      id: id ?? this.id,
      theatreId: theatreId ?? this.theatreId,
      movieId: movieId ?? this.movieId,
      time: time ?? this.time,
      date: date ?? this.date,
      screenName: screenName ?? this.screenName,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'ShowModel(id: $id, theatreId: $theatreId, movieId: $movieId, time: $time, date: $date, screenName: $screenName, status: $status)';
  }
}
