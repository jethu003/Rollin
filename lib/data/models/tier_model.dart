

import 'package:rollin_user/domain/entities/seat_entity.dart';

class TierModel extends Tier {
  TierModel({required super.name, required super.price, required super.layout});

  factory TierModel.fromMap(Map<String, dynamic> map) {
    return TierModel(
      name: map['tierName'],
      price: map['price'],
      layout: List<List<String>>.from(
          (map['rows'] as List).map((row) => List<String>.from(row))),
    );
  }
}
