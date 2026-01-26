// import 'package:cloud_firestore/cloud_firestore.dart';

// abstract class TheatreDetailsState {}

// class TheatreLoading extends TheatreDetailsState {}

// class TheatreLoaded extends TheatreDetailsState {
//   final List<QueryDocumentSnapshot<Map<String, dynamic>>> shows;
//   final DateTime selectedDate;

//   TheatreLoaded({
//     required this.shows,
//     required this.selectedDate,
//   });
// }

// class TheatreError extends TheatreDetailsState {
//   final String message;
//   TheatreError(this.message);
// }

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class TheatreDetailsState {}

class TheatreLoading extends TheatreDetailsState {}

class TheatreLoaded extends TheatreDetailsState {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> shows;
  final Map<int, Map<String, dynamic>> movies;
  final DateTime selectedDate;

  TheatreLoaded({
    required this.shows,
    required this.movies,
    required this.selectedDate,
  });
}

class TheatreError extends TheatreDetailsState {
  final String message;
  TheatreError(this.message);
}

