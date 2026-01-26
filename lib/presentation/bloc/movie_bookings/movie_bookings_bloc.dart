import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rollin_user/domain/usecases/movie_booking_usecase.dart';
import 'package:rollin_user/presentation/bloc/movie_bookings/movie_bookings_event.dart';
import 'package:rollin_user/presentation/bloc/movie_bookings/movie_bookings_state.dart';


class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetUserBookings getUserBookings;

  BookingBloc(this.getUserBookings) : super(BookingInitial()) {
    on<FetchUserBookings>((event, emit) async {
      emit(BookingLoading());
      try {
        final bookings = await getUserBookings(event.userId);
        emit(BookingLoaded(bookings));
      } catch (e) {
        emit(BookingError(e.toString()));
      }
    });
  }
}