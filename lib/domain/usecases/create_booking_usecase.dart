import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class CreateBookingUseCase {
  final BookingRepository repository;

  CreateBookingUseCase(this.repository);

  Future<void> call(BookingEntity booking, String userId) {
    return repository.createBooking(booking, userId);
  }
}
