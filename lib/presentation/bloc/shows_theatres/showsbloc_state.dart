

abstract class ShowState {}

class ShowInitial extends ShowState {}

class ShowLoading extends ShowState {}

class ShowLoaded extends ShowState {
  final List<Map<String, dynamic>> shows;
  ShowLoaded(this.shows);
}

class ShowError extends ShowState {
  final String message;
  ShowError(this.message);
}
