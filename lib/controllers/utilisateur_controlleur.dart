import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/utilisateur_model.dart';

class UtilisateurControlleur {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Créer un utilisateur
  Future<void> creerUtilisateur(String email, String motDePasse, String role) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: motDePasse,
    );

    await _firestore.collection('utilisateurs').doc(userCredential.user!.uid).set({
      'email': email,
      'role': role,
      'dateCreation': DateTime.now(),
    });
  }

  // Supprimer un utilisateur
  Future<void> supprimerUtilisateur(String id) async {
    // Supprimer de Firestore
    await _firestore.collection('utilisateurs').doc(id).delete();

    // Supprimer de Authentication (optionnel, nécessite que l'utilisateur soit connecté)
    try {
      User? user = _auth.currentUser;
      if (user != null && user.uid == id) {
        await user.delete();
      }
    } catch (e) {
      print("Impossible de supprimer depuis Auth: $e");
    }
  }

  // Obtenir tous les utilisateurs
  Stream<List<Utilisateur>> getTousUtilisateurs() {
    return _firestore.collection('utilisateurs').snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => Utilisateur.fromMap(doc.id, doc.data())).toList());
  }
}
