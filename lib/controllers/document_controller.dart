import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/document_model.dart';

class DocumentController {
  final CollectionReference col =
      FirebaseFirestore.instance.collection('documents');

  /// ajouter un document et faire id automatique 
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

  /// modifier un document
  Future<void> updateDocument(DocumentModel doc) async {
    if (doc.id.isEmpty) return;
    try {
      await col.doc(doc.id).update(doc.toMap());
      print("Document mis à jour : ${doc.toMap()}");
    } catch (e) {
      print("Erreur lors de la mise à jour : $e");
    }
  }

  ///supprimer un document selon id 
  Future<void> deleteDocument(String id) async {
    try {
      await col.doc(id).delete();
      print("Document supprimé : $id");
    } catch (e) {
      print("Erreur lors de la suppression : $e");
    }
  }

  /// pour afficher tout les document dans interface gestion documents
  Stream<List<DocumentModel>> allDocuments() {
    return col.snapshots().map((snap) => snap.docs
        .map((d) =>
            DocumentModel.fromMap(d.id, d.data() as Map<String, dynamic>))
        .toList());
  }

  /// on va rechercher un document par titre 
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
