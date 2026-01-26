abstract class TheatreDetailsEvent {}

class LoadShows extends TheatreDetailsEvent {
  final String theatreId;
  LoadShows(this.theatreId);
}

class ChangeDate extends TheatreDetailsEvent {
  final DateTime date;
  ChangeDate(this.date);
}
