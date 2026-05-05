import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/souvenir_model.dart';

class SouvenirService {
  final CollectionReference _db = FirebaseFirestore.instance.collection('souvenirs');

  Stream<List<SouvenirModel>> getSouvenirs() {
    return _db.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => SouvenirModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList());
  }

  Future<void> addSouvenir(SouvenirModel souvenir) => _db.add(souvenir.toMap());

  // ESTA ES LA FUNCIÓN NUEVA PARA EDITAR
  Future<void> updateSouvenir(SouvenirModel souvenir) {
    return _db.doc(souvenir.id).update(souvenir.toMap());
  }

  Future<void> deleteSouvenir(String id) => _db.doc(id).delete();
}