import 'package:rollin_user/domain/entities/home_page_entity.dart';

abstract class MovieRepository {
  Future<List<MovieEntity>> getNowPlayingMovies();
}
