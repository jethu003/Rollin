class MovieModel {
  final int id;
  final String title;
  final String posterUrl;
  final String backdropUrl;
  final double rating;
  final String language;
  final String overview;
  final String releaseDate;
  final String trailerUrl;
  final List<String> genres;
  final List<Map<String, dynamic>> cast;
  final List<Map<String, dynamic>> crew;

  MovieModel({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.backdropUrl,
    required this.rating,
    required this.language,
    required this.overview,
    required this.releaseDate,
    required this.trailerUrl,
    required this.genres,
    this.cast = const [],
    this.crew = const [],
  });

  factory MovieModel.fromMap(Map<String, dynamic> map) {
    List<Map<String, dynamic>> safeCast = [];
    List<Map<String, dynamic>> safeCrew = [];

    if (map['cast'] != null && map['cast'] is List) {
      safeCast = List<Map<String, dynamic>>.from(
        (map['cast'] as List).map((e) => Map<String, dynamic>.from(e)),
      );
    }

    if (map['crew'] != null && map['crew'] is List) {
      safeCrew = List<Map<String, dynamic>>.from(
        (map['crew'] as List).map((e) => Map<String, dynamic>.from(e)),
      );
    }

    return MovieModel(
      id: map['id'] is int
          ? map['id']
          : int.tryParse(map['id']?.toString() ?? '0') ?? 0,
      title: map['title']?.toString() ?? '',
      posterUrl: map['posterUrl']?.toString() ?? '',
      backdropUrl: map['backdropUrl']?.toString() ?? '',
      rating: (map['rating'] is num) ? (map['rating'] as num).toDouble() : 0.0,
      language: map['language']?.toString() ?? '',
      overview: map['overview']?.toString() ?? '',
      releaseDate: map['release_date']?.toString() ?? '',
      trailerUrl: map['trailerUrl']?.toString() ?? '',
      genres: (map['genres'] is List)
          ? List<String>.from(map['genres'].map((e) => e.toString()))
          : [],
      cast: safeCast,
      crew: safeCrew,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'posterUrl': posterUrl,
      'backdropUrl': backdropUrl,
      'rating': rating,
      'language': language,
      'overview': overview,
      'release_date': releaseDate,
      'trailerUrl': trailerUrl,
      'genres': genres,
      'cast': cast,
      'crew': crew,
    };
  }
}
