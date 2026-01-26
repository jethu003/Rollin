
import 'package:rollin_user/data/models/booking_model.dart';
import 'package:rollin_user/data/repositories/movie_bookings_repository.dart';

class GetUserBookings {
  final BookingRepository repository;

  GetUserBookings(this.repository);

  Future<List<BookingModel>> call(String userId) async {
    return repository.getUserBookings(userId);
  }
}
