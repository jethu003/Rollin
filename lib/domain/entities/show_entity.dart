class ShowEntity {
  final String id;
  final String movieTitle;
  final int movieId;
  final String posterUrl;
  final String screenId;
  final String screenName;
  final String theatreId;
  final String status;
  final DateTime createdAt;
  final List<ShowDateEntity> dates;
  final List<TierEntity> tiers;

  ShowEntity({
    required this.id,
    required this.movieTitle,
    required this.movieId,
    required this.posterUrl,
    required this.screenId,
    required this.screenName,
    required this.theatreId,
    required this.status,
    required this.createdAt,
    required this.dates,
    required this.tiers,
  });
}

class ShowDateEntity {
  final String date; 
  final List<TimingEntity> timings;

  ShowDateEntity({
    required this.date,
    required this.timings,
  });
}

class TimingEntity {
  final String time; 
  final Map<String, dynamic> layout; 

  TimingEntity({
    required this.time,
    required this.layout,
  });
}

class TierEntity {
  final String tierName;
  final int cols;
  final List<int> colPartitions;
  final RowPartition rowPartitions;
  final double price;

  TierEntity({
    required this.tierName,
    required this.cols,
    required this.colPartitions,
    required this.rowPartitions,
    required this.price,
  });
}

class RowPartition {
  final int rows;
  RowPartition({required this.rows});
}


