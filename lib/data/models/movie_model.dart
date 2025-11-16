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
  });

  /// ✅ Create from Firestore / Map
  factory MovieModel.fromMap(Map<String, dynamic> map) {
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
    );
  }

  /// ✅ Convert back to JSON/Map
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
    };
  }

  /// ✅ Optional: copyWith
  MovieModel copyWith({
    int? id,
    String? title,
    String? posterUrl,
    String? backdropUrl,
    double? rating,
    String? language,
    String? overview,
    String? releaseDate,
    String? trailerUrl,
    List<String>? genres,
  }) {
    return MovieModel(
      id: id ?? this.id,
      title: title ?? this.title,
      posterUrl: posterUrl ?? this.posterUrl,
      backdropUrl: backdropUrl ?? this.backdropUrl,
      rating: rating ?? this.rating,
      language: language ?? this.language,
      overview: overview ?? this.overview,
      releaseDate: releaseDate ?? this.releaseDate,
      trailerUrl: trailerUrl ?? this.trailerUrl,
      genres: genres ?? this.genres,
    );
  }

  @override
  String toString() {
    return 'MovieModel(id: $id, title: $title, rating: $rating, language: $language, genres: $genres)';
  }
}
