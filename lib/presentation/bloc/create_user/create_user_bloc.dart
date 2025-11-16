import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rollin_user/domain/usecases/register_usecase.dart';
import 'package:rollin_user/presentation/bloc/create_user/create_user_event.dart';
import 'package:rollin_user/presentation/bloc/create_user/create_user_state.dart';


class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUserUseCase registerUserUseCase;

  RegisterBloc({required this.registerUserUseCase}) : super(RegisterInitial()) {
    on<RegisterButtonPressed>((event, emit) async {
      emit(RegisterLoading());
      try {
        await registerUserUseCase(
          name: event.name,
          email: event.email,
          password: event.password,
        );
        emit(RegisterSuccess());
      } catch (e) {
        emit(RegisterFailure(e.toString()));
      }
    });
  }
}
