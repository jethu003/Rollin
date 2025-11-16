abstract class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieSuccess extends MovieState {
  final List movies;
  MovieSuccess(this.movies);
}

class MovieFailure extends MovieState {
  final String message;
  MovieFailure(this.message);
}
