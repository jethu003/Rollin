// data/datasources/cinema_remote_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rollin_user/data/models/cinemas_model.dart';


abstract class CinemaRemoteDataSource {
  Future<List<CinemaModel>> fetchCinemas();
}

class CinemaRemoteDataSourceImpl implements CinemaRemoteDataSource {
  final FirebaseFirestore firestore;

  CinemaRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<CinemaModel>> fetchCinemas() async {
    final showsSnap = await firestore.collection('shows').get();

    final theatreIds = showsSnap.docs
        .map((doc) => doc['theatreId'])
        .whereType<String>()
        .toSet();

    final List<CinemaModel> cinemas = [];

    for (final id in theatreIds) {
      final doc = await firestore.collection('userprofile').doc(id).get();
      if (doc.exists) {
        final data = doc.data()!;
        cinemas.add(
          CinemaModel(
            id: id,
            name: data['name'] ?? 'Unknown',
            location: data['city'] ?? '',
            image: (data['images'] as List?)?.first ?? '',
          ),
        );
      }
    }

    return cinemas;
  }
}
