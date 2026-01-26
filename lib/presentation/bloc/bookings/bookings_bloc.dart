import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rollin_user/domain/usecases/upload_userbookings_usecase.dart';
import 'package:rollin_user/presentation/bloc/bookings/bookings_event.dart';
import 'package:rollin_user/presentation/bloc/bookings/bookings_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final UploadBookingUseCase uploadBookingUseCase;

  BookingBloc(this.uploadBookingUseCase) : super(BookingInitial()) {
    on<UploadBookingEvent>((event, emit) async {
      emit(BookingLoading());
      try {
        final bookingId = await uploadBookingUseCase(
          showId: event.showId,
          theatreId: event.theatreId,
          movieTitle: event.movieTitle,
          showTime: event.showTime,
          lockedSeats: event.lockedSeats,
          tiers: event.tiers,
          totalPrice: event.totalPrice,
          theatreName: event.theatreName,
          posterUrl: event.posterUrl,
          showDate: event.showDate,
        );
        emit(BookingSuccess(bookingId));
      } catch (e) {
        emit(BookingFailure(e.toString()));
      }
    });
  }
}
