import 'package:rollin_user/domain/entities/booking_entity.dart';

abstract class BookingRepository {
  Future<void> createBooking(BookingEntity booking, String userId);
}
