import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/document_model.dart';

class DocumentController {
  final CollectionReference col =
      FirebaseFirestore.instance.collection('documents');

  /// Add a document and return it with the generated ID (automatique)
  Future<DocumentModel?> addDocument(DocumentModel doc) async {
    try {
      final docRef = await col.add(doc.toMap());
      final newDoc = DocumentModel(
        id: docRef.id,
        title: doc.title,
        author: doc.author,
        category: doc.category,
        year: doc.year,
        available: doc.available,
      );
      print("Document ajouté : ${newDoc.toMap()}");
      return newDoc;
    } catch (e) {
      print("Erreur lors de l'ajout : $e");
      return null;
    }
  }

  /// Update document safely
  Future<void> updateDocument(DocumentModel doc) async {
    if (doc.id.isEmpty) return;
    try {
      await col.doc(doc.id).update(doc.toMap());
      print("Document mis à jour : ${doc.toMap()}");
    } catch (e) {
      print("Erreur lors de la mise à jour : $e");
    }
  }

  /// Delete document safely
  Future<void> deleteDocument(String id) async {
    try {
      await col.doc(id).delete();
      print("Document supprimé : $id");
    } catch (e) {
      print("Erreur lors de la suppression : $e");
    }
  }

  /// Stream all documents
  Stream<List<DocumentModel>> allDocuments() {
    return col.snapshots().map((snap) => snap.docs
        .map((d) =>
            DocumentModel.fromMap(d.id, d.data() as Map<String, dynamic>))
        .toList());
  }

  /// Search documents by title
  Stream<List<DocumentModel>> search(String term) {
    return col
        .where('title', isEqualTo: term.trim())
        .snapshots()
        .map((snap) => snap.docs
            .map((d) =>
                DocumentModel.fromMap(d.id, d.data() as Map<String, dynamic>))
            .toList());
  }
}
