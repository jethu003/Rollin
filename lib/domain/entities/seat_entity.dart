class Seat {
  final String id;
  final String row;
  final int number;
  final String tier;

  Seat({
    required this.id,
    required this.row,
    required this.number,
    required this.tier,
  });
}
class Tier {
  final String name;
  final int price;
  final List<List<String>> layout; // list of rows with seat numbers

  Tier({required this.name, required this.price, required this.layout});
}


class ShowLayout {
  final List<Tier> tiers;
  final Map<String, int> tempLocks; // seatId -> expiry timestamp
  final Set<String> bookedSeats;

  ShowLayout({required this.tiers, required this.tempLocks, required this.bookedSeats});
}
