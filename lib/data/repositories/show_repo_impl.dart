
import 'package:rollin_user/data/datasources/firestore_datasource.dart';
import 'package:rollin_user/domain/repositories/show_repository.dart';

class ShowRepositoryImpl implements ShowRepository {
  final FirestoreDataSource dataSource;

  ShowRepositoryImpl(this.dataSource);

  @override
  Future<List<Map<String, dynamic>>> getShowsWithDetails() {
    return dataSource.getShowsWithDetails();
  }
}
