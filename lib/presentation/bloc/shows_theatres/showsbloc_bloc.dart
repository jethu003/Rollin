import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rollin_user/domain/usecases/show_usecase.dart';
import 'package:rollin_user/presentation/bloc/shows_theatres/showsbloc_event.dart';
import 'package:rollin_user/presentation/bloc/shows_theatres/showsbloc_state.dart';

class ShowBloc extends Bloc<ShowEvent, ShowState> {
  final GetShowsWithDetails getShows;

  ShowBloc(this.getShows) : super(ShowInitial()) {
    on<FetchShows>((event, emit) async {
      emit(ShowLoading());
      try {
        final data = await getShows();
        emit(ShowLoaded(data));
      } catch (e) {
        emit(ShowError(e.toString()));
      }
    });
  }
}
