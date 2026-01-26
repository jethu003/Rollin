import 'package:rollin_user/domain/entities/theatre_details.dart';
import 'package:rollin_user/domain/repositories/thetre_detail_repository.dart';

class GetShowsByTheatre {
  final ShowRepository repository;

  GetShowsByTheatre(this.repository);

  Future<List<ShowEntity>> call(String theatreId) {
    return repository.getShowsByTheatre(theatreId);
  }
}
