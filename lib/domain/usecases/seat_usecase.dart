




import 'package:rollin_user/domain/entities/seat_entity.dart';
import 'package:rollin_user/domain/repositories/seat_repository.dart';

class GetShowLayout {
  final ShowRepository repository;

  GetShowLayout(this.repository);

  Future<ShowLayout> call(String showId) async {
    return await repository.getShowLayout(showId);
  }
}



class LockSeats {
  final ShowRepository repository;

  LockSeats(this.repository);

  Future<void> call(String showId, List<String> seatIds, int lockDuration) async {
    await repository.lockSeats(showId, seatIds, lockDuration);
  }
}

