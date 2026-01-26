

import 'package:rollin_user/data/datasources/booking_datasource.dart';
import 'package:rollin_user/data/models/booking_model.dart';

abstract class BookingRepository {
  Future<List<BookingModel>> getUserBookings(String userId);
}

class BookingRepositoryImpl implements BookingRepository {
  final BookingDataSource dataSource;

  BookingRepositoryImpl(this.dataSource);

  @override
  Future<List<BookingModel>> getUserBookings(String userId) {
    return dataSource.getUserBookings(userId);
  }
}
