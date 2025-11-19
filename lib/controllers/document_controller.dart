import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/document_model.dart';

class DocumentController {
  final CollectionReference col =
      FirebaseFirestore.instance.collection('documents');

  // Ajouter un document
  Future<void> addDocument(DocumentModel doc) async {
    await col.add(doc.toMap());
  }

  // Modifier un document
  Future<void> updateDocument(DocumentModel doc) async {
    if (doc.id.isNotEmpty) {
      await col.doc(doc.id).update(doc.toMap());
    }
  }

  // Supprimer un document
  Future<void> deleteDocument(String id) async {
    await col.doc(id).delete();
  }

  // Tous les documents
  Stream<List<DocumentModel>> allDocuments() {
    return col.snapshots().map((snap) =>
        snap.docs
            .map((d) => DocumentModel.fromMap(d.id, d.data() as Map<String, dynamic>))
            .toList());
  }

  // Recherche par titre
  Stream<List<DocumentModel>> search(String term) {
    return col
        .where('titre', isEqualTo: term.trim())
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => DocumentModel.fromMap(d.id, d.data() as Map<String, dynamic>)).toList());
  }
}
