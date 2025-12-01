import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/emprunt_model.dart';

class EmpruntControlleur {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Ajouter un emprunt
  Future<void> ajouterEmprunt(EmpruntModel emprunt) async {
    await _firestore.collection('emprunts').add(emprunt.toMap());
  }

  // Rendre un emprunt
  Future<void> rendreDocument(String empruntId) async {
    await _firestore.collection('emprunts').doc(empruntId).update({'rendu': true});
  }

  // Supprimer un emprunt
  Future<void> supprimerEmprunt(String empruntId) async {
    await _firestore.collection('emprunts').doc(empruntId).delete();
  }

  // Obtenir tous les emprunts **sans filtrer par utilisateur**
  Stream<List<EmpruntModel>> getTousEmprunts() {
    return _firestore.collection('emprunts').snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => EmpruntModel.fromMap(doc.id, doc.data())).toList());
  }
}
