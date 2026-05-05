import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference _db = FirebaseFirestore.instance.collection('medicamentos');

  Stream<QuerySnapshot> getMedicamentos() => _db.snapshots();

  Future<void> addMedicamento(String nom, String sus, double pre, int sto) {
    return _db.add({
      'nombre': nom,
      'sustancia': sus,
      'precio': pre,
      'stock': sto,
    });
  }

  // ESTA ES LA FUNCIÓN NUEVA PARA EDITAR
  Future<void> updateMedicamento(String id, Map<String, dynamic> datos) {
    return _db.doc(id).update(datos);
  }

  Future<void> deleteMedicamento(String id) => _db.doc(id).delete();
}