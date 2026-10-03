
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
    try {
      final showsSnap = await firestore
          .collection('shows')
          .where('status', isEqualTo: 'active') 
          .get();

      //  extract valid theatreIds
      final theatreIds = showsSnap.docs
          .map((doc) => doc.data()['theatreId'])
          .whereType<String>()
          .where((id) => id.isNotEmpty)
          .toSet();

      final List<CinemaModel> cinemas = [];

      for (final id in theatreIds) {
        try {
          final doc =
              await firestore.collection('userprofile').doc(id).get();

          if (!doc.exists) continue;

          final data = doc.data()!;
          final images = data['images'];

          cinemas.add(
            CinemaModel(
              id: id,
              name: data['name']?.toString() ?? 'Unknown',
              location: data['city']?.toString() ?? '',
              image: images is List && images.isNotEmpty
                  ? images.first.toString()
                  : '',
            ),
          );
        } catch (e) {
          
          print('Cinema fetch error for theatre $id: $e');
        }
      }

      return cinemas;
    } catch (e) {
      print('Failed to load cinemas: $e');
      return [];
    }
  }
}
