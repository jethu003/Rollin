class MovieEntity {
  final int id;
  final String title;
  final String overview;
  final String language;
  final double rating;
  final String releaseDate;
  final String posterUrl;
  final String backdropUrl;
  final String trailerUrl;
  final List<String> genres;
  final List<CastEntity> cast;
  final List<CrewEntity> crew;

  MovieEntity({
    required this.id,
    required this.title,
    required this.overview,
    required this.language,
    required this.rating,
    required this.releaseDate,
    required this.posterUrl,
    required this.backdropUrl,
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

  CastEntity({
    required this.name,
    required this.character,
    required this.profileUrl,
  });
}

class CrewEntity {
  final String name;
  final String job;

  CrewEntity({
    required this.name,
    required this.job,
  });
}
