import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/emprunt_model.dart';
import '../models/document_model.dart';
import '../models/utilisateur_model.dart';

class FirestoreService {
final FirebaseFirestore _db = FirebaseFirestore.instance;

// Récupérer tous les emprunts
Future<List<EmpruntModel>> getEmprunts() async {
QuerySnapshot snapshot = await _db.collection('emprunts').get();
return snapshot.docs
.map((doc) => EmpruntModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
.toList();
}

// Récupérer tous les documents
Future<List<DocumentModel>> getDocuments() async {
QuerySnapshot snapshot = await _db.collection('documents').get();
return snapshot.docs
.map((doc) => DocumentModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
.toList();
}

// Récupérer tous les utilisateurs depuis Firestore
Future<List<Utilisateur>> getUtilisateurs() async {
QuerySnapshot snapshot = await _db.collection('utilisateurs').get();
return snapshot.docs.map((doc) {
final data = doc.data() as Map<String, dynamic>;
return Utilisateur(
id: doc.id,
email: data['email'] ?? 'Inconnu',
role: data['role'] ?? '',
);
}).toList();
}
}
