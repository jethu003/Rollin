import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rollin_user/presentation/bloc/login_user/login_user_event.dart';
import 'package:rollin_user/presentation/bloc/login_user/login_user_state.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuth firebaseAuth;

  LoginBloc({required this.firebaseAuth}) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      try {
        await firebaseAuth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(LoginSuccess());
      } on FirebaseAuthException catch (e) {
        emit(LoginFailure(e.message ?? 'Login failed'));
      } catch (e) {
        emit(LoginFailure('Login failed: $e'));
      }
    });
  }
}
