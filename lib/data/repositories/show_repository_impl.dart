




import 'package:rollin_user/data/datasources/show_remote_datasource.dart';
import 'package:rollin_user/domain/entities/seat_entity.dart';
import 'package:rollin_user/domain/repositories/seat_repository.dart';



class ShowRepositoryImpl implements ShowRepository {
  final ShowRemoteDataSource remoteDataSource;

  ShowRepositoryImpl(this.remoteDataSource);

  @override
  Future<ShowLayout> getShowLayout(String showId) async {
    return await remoteDataSource.fetchShowLayout(showId);
  }

  @override
  Future<void> lockSeats(String showId, List<String> seatIds, int lockDuration) async {
    await remoteDataSource.lockSeats(showId, seatIds, lockDuration);
  }
}
