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

  // Modifier un emprunt
  Future<void> modifierEmprunt(String empruntId, Map<String, dynamic> nouvellesValeurs) async {
    await _firestore.collection('emprunts').doc(empruntId).update(nouvellesValeurs);
  }

  // Supprimer un emprunt
  Future<void> supprimerEmprunt(String empruntId) async {
    await _firestore.collection('emprunts').doc(empruntId).delete();
  }

  // Obtenir les emprunts d'un utilisateur
  Stream<List<EmpruntModel>> getEmpruntsUtilisateur(String idUtilisateur) {
    return _firestore
        .collection('emprunts')
        .where('idUtilisateur', isEqualTo: idUtilisateur)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => EmpruntModel.fromMap(doc.id, doc.data())).toList());
  }

  // Rechercher des emprunts par ID de document
  Stream<List<EmpruntModel>> rechercherEmprunt(String idUtilisateur, String motCle) {
    return _firestore
        .collection('emprunts')
        .where('idUtilisateur', isEqualTo: idUtilisateur)
        .where('idDocument', isGreaterThanOrEqualTo: motCle)
        .where('idDocument', isLessThanOrEqualTo: motCle + '\uf8ff')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => EmpruntModel.fromMap(doc.id, doc.data())).toList());
  }
}
