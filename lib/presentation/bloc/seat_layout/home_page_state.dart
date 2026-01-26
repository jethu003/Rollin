import 'package:equatable/equatable.dart';
import 'package:rollin_user/domain/entities/home_page_entity.dart';


abstract class TheatreMoviesState extends Equatable {
  const TheatreMoviesState();

  @override
  List<Object?> get props => [];
}

/// Initial / Loading
class TheatreMoviesLoading extends TheatreMoviesState {}

/// Success
class TheatreMoviesLoaded extends TheatreMoviesState {
  final List<MovieEntity> movies;

  const TheatreMoviesLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

/// Error
class TheatreMoviesError extends TheatreMoviesState {
  final String message;

  const TheatreMoviesError(this.message);

  @override
  List<Object?> get props => [message];
}
