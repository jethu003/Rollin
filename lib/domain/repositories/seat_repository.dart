



import 'package:rollin_user/domain/entities/seat_entity.dart';

abstract class ShowRepository {
  Future<ShowLayout> getShowLayout(String showId);
  Future<void> lockSeats(String showId, List<String> seatIds, int lockDuration);
}
