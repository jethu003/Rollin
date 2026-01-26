import 'dart:io';

abstract class ProfileEvent {}

class FetchProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final Map<String, dynamic> data;
  final File? image;
  UpdateProfile(this.data, {this.image});
}
