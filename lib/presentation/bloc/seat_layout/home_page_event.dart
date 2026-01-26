import 'package:equatable/equatable.dart';

abstract class TheatreMoviesEvent extends Equatable {
  const TheatreMoviesEvent();

  @override
  List<Object?> get props => [];
}

/// Trigger movie loading
class LoadTheatreMovies extends TheatreMoviesEvent {}
