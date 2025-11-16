

import 'package:rollin_user/domain/entities/coming_soon.dart';

abstract class MovieRepository {
  Future<List<MovieEntity>> getComingSoonMovies();
}
