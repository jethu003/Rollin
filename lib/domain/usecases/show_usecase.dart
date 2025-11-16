import '../repositories/show_repository.dart';

class GetShowsWithDetails {
  final ShowRepository repository;

  GetShowsWithDetails(this.repository);

  Future<List<Map<String, dynamic>>> call() async {
    return await repository.getShowsWithDetails();
  }
}
