import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Inscription
  Future<AppUser?> register(String email, String password, String role) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return AppUser(
        uid: userCredential.user!.uid,
        email: email,
        role: role,
      );
    } catch (e) {
      print('Erreur inscription: $e');
      return null;
    }
  }

  // Connexion
  Future<AppUser?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      // Par défaut rôle = 'apprenant_loge' si non défini dans ta logique
      return AppUser(
        uid: userCredential.user!.uid,
        email: email,
        role: 'apprenant_loge',
      );
    } catch (e) {
      print('Erreur connexion: $e');
      return null;
    }
  }

  // Déconnexion
  Future<void> logout() async {
    await _auth.signOut();
  }
}
