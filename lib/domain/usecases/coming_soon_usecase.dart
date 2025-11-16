import 'package:rollin_user/domain/entities/coming_soon.dart';
import 'package:rollin_user/domain/repositories/coming_soon_repository.dart';



class GetComingSoonMovies {
  final MovieRepository repository;

  GetComingSoonMovies(this.repository);

  Future<List<MovieEntity>> call() async {
    return await repository.getComingSoonMovies();
  }
}
