

import 'package:rollin_user/domain/entities/theatre_details.dart';

class ShowModel extends ShowEntity {
  ShowModel({
    required super.id,
    required super.theatreId,
    required super.movieTitle,
    required super.posterUrl,
    required super.date,
    required super.time,
  });

  factory ShowModel.fromMap(String id, Map<String, dynamic> map) {
    return ShowModel(
      id: id,
      theatreId: map['theatreId'],
      movieTitle: map['movieTitle'],
      posterUrl: map['posterUrl'] ?? '',
      date: map['date'],
      time: map['time'],
    );
  }
}
