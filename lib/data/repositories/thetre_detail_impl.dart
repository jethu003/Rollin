import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rollin_user/data/models/theatre_detais_model.dart';
import 'package:rollin_user/domain/entities/theatre_details.dart';
import 'package:rollin_user/domain/repositories/thetre_detail_repository.dart';


class ShowRepositoryImpl implements ShowRepository {
  final FirebaseFirestore firestore;

  ShowRepositoryImpl(this.firestore);

  @override
  Future<List<ShowEntity>> getShowsByTheatre(String theatreId) async {
    final snap = await firestore
        .collection('shows')
        .where('theatreId', isEqualTo: theatreId)
        .get();

    return snap.docs
        .map((e) => ShowModel.fromMap(e.id, e.data()))
        .toList();
  }
}
