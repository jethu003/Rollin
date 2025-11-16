class MovieEntity {
  final String id;
  final String title;
  final String backdropUrl;
  final String posterUrl;
  final String language;
  final String overview;
  final double rating;
  final String releaseDate;
  final String trailerUrl;
  final List<String> genres;
  final List<CastEntity> cast;
  final List<CrewEntity> crew;

  MovieEntity({
    required this.id,
    required this.title,
    required this.backdropUrl,
    required this.posterUrl,
    required this.language,
    required this.overview,
    required this.rating,
    required this.releaseDate,
    required this.trailerUrl,
    required this.genres,
    required this.cast,
    required this.crew,
  });
}

class CastEntity {
  final String name;
  final String character;
  final String profileUrl;

  CastEntity({required this.name, required this.character, required this.profileUrl});
}

class CrewEntity {
  final String name;
  final String job;

  CrewEntity({required this.name, required this.job});
}
