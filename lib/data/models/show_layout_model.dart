

import 'package:rollin_user/domain/entities/seat_entity.dart';

import 'tier_model.dart';

class ShowLayoutModel extends ShowLayout {
  ShowLayoutModel({
    required super.tiers,
    required super.tempLocks,
    required super.bookedSeats,
  });

  factory ShowLayoutModel.fromMap(String id, Map<String, dynamic> map) {
    final tiersData = List<Map<String, dynamic>>.from(map['tiers'] ?? []);
    final tiers = tiersData.map((t) => TierModel.fromMap(t)).toList();

    final booked = Set<String>.from((map['bookedSeats'] ?? {}).keys);
    final tempLocks = Map<String, int>.from(map['tempLocks'] ?? {});

    return ShowLayoutModel(tiers: tiers, bookedSeats: booked, tempLocks: tempLocks);
  }
}
