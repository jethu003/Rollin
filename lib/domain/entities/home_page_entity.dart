class MovieEntity {
  final int id;
  final String title;
  final String posterUrl;
  final String backdropUrl;
  final String language;
  final String releaseDate;
  final List<String> genres;
  final String overview;
  final List<Map<String, dynamic>> cast;
  final List<Map<String, dynamic>> crew;
  final String trailorUrl;

  const MovieEntity( {
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.backdropUrl,
    required this.language,
    required this.releaseDate,
    required this.genres,
    required this.overview,
    required this.cast,
    required this.crew,
    required this.trailorUrl
  });
}
