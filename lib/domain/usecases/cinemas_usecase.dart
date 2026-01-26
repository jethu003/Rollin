

import 'package:rollin_user/domain/entities/cinemas_entity.dart';
import 'package:rollin_user/domain/repositories/cinemas_repository.dart';

class GetCinemas {
  final CinemaRepository repository;

  GetCinemas(this.repository);

  Future<List<CinemaEntity>> call() {
    return repository.getCinemas();
  }
}
