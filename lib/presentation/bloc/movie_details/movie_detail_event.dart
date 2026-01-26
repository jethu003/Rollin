abstract class MovieDetailsEvent {}

class LoadTheatresForMovie extends MovieDetailsEvent {
  final int movieId;

  LoadTheatresForMovie(this.movieId);
}
