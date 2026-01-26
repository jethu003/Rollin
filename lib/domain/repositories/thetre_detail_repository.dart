import 'package:rollin_user/domain/entities/theatre_details.dart';

abstract class ShowRepository {
  Future<List<ShowEntity>> getShowsByTheatre(String theatreId);
}
