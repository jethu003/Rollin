


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rollin_user/data/repositories/profile_screen_repository.dart';
import 'package:rollin_user/presentation/bloc/bloc/profile_page_event.dart';
import 'package:rollin_user/presentation/bloc/bloc/profile_page_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc(this.repository) : super(ProfileLoading()) {
    on<FetchProfile>(_onFetchProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onFetchProfile(
    FetchProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final data = await repository.fetchUserProfile();
      emit(ProfileLoaded( data));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await repository.updateProfile(event.data);
      add(FetchProfile()); // refresh after update
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}

