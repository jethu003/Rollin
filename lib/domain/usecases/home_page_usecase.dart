import 'package:rollin_user/domain/entities/home_page_entity.dart';
import 'package:rollin_user/domain/repositories/home_page_repository.dart';

class GetNowPlayingMovies {
  final MovieRepository repository;

  GetNowPlayingMovies(this.repository);

  Future<List<MovieEntity>> call() {
    return repository.getNowPlayingMovies();
  }
}
