

import 'package:rollin_user/data/datasources/cinemas_datasource.dart';
import 'package:rollin_user/domain/entities/cinemas_entity.dart';
import 'package:rollin_user/domain/repositories/cinemas_repository.dart';

class CinemaRepositoryImpl implements CinemaRepository {
  final CinemaRemoteDataSource remoteDataSource;

  CinemaRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CinemaEntity>> getCinemas() {
    return remoteDataSource.fetchCinemas();
  }
}
