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

  // Connexion utilisateur
  Future<User?> connexionUtilisateur(String email, String motDePasse) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: motDePasse,
    );
    return userCredential.user;
  }

  // Déconnexion
  Future<void> deconnexion() async {
    await _auth.signOut();
  }

  // Supprimer un utilisateur
  Future<void> supprimerUtilisateur(String id) async {
    await _firestore.collection('utilisateurs').doc(id).delete();
  }

  // Obtenir tous les utilisateurs
  Stream<List<Utilisateur>> getTousUtilisateurs() {
    return _firestore.collection('utilisateurs').snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => Utilisateur.fromMap(doc.id, doc.data())).toList());
  }
}
