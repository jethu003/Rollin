

import 'package:rollin_user/domain/entities/cinemas_entity.dart';

abstract class CinemaRepository {
  Future<List<CinemaEntity>> getCinemas();
}
