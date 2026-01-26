

import 'package:rollin_user/domain/entities/cinemas_entity.dart';

abstract class CinemaState {}

class CinemaLoading extends CinemaState {}

class CinemaLoaded extends CinemaState {
  final List<CinemaEntity> cinemas;

  CinemaLoaded(this.cinemas);
}

class CinemaError extends CinemaState {
  final String message;

  CinemaError(this.message);
}
