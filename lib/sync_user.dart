import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> syncUserToFirestore(User user) async {
  final docRef = FirebaseFirestore.instance.collection('utilisateurs').doc(user.uid);
  final doc = await docRef.get();

  if (!doc.exists) {
    await docRef.set({
      'email': user.email ?? 'Inconnu',
      'role': 'utilisateur',
    });
  }
}
