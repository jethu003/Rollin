

import 'package:rollin_user/domain/entities/home_page_entity.dart';

class MovieModel extends MovieEntity {
  MovieModel({
    required super.id,
    required super.title,
    required super.posterUrl,
    required super.backdropUrl,
    required super.language,
    required super.releaseDate,
    required super.genres,
    required super.overview,
    required super.cast,
    required super.crew, required super.trailorUrl,
    
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'] ?? '',
      posterUrl: json['posterUrl'] ?? '',
      backdropUrl: json['backdropUrl'] ?? '',
      language: json['language'] ?? '',
      releaseDate: json['releaseDate'] ?? '',
      genres: List<String>.from(json['genres'] ?? []),
      overview: json['overview'] ?? '',
      cast: List<Map<String, dynamic>>.from(json['cast'] ?? []),
      crew: List<Map<String, dynamic>>.from(json['crew'] ?? []),
      trailorUrl: json['trailerUrl'],
    );
  }
}
