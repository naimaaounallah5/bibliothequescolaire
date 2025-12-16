import 'package:flutter/material.dart';
import 'document_list_vue.dart';
import 'document_form_vue.dart';
import '../models/document_model.dart';

class DocumentVue extends StatefulWidget {
  const DocumentVue({super.key});

  @override
  State<DocumentVue> createState() => _DocumentVueState();
}

class _DocumentVueState extends State<DocumentVue> {
  bool afficherFormulaire = false;
  DocumentModel? documentModifie;

  // Basculer entre la liste et le formulaire, optionnellement avec un document à modifier
  void basculerVue([DocumentModel? doc]) {
    setState(() {
      documentModifie = doc;
      afficherFormulaire = !afficherFormulaire;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Documents'),
        backgroundColor: Colors.teal,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: afficherFormulaire
            ? DocumentFormVue(
                key: const ValueKey('formulaire'),
                document: documentModifie,
                onSave: () => basculerVue(),
              )
            : DocumentListVue(
                key: const ValueKey('liste'),
                onEdit: (doc) => basculerVue(doc),
              ),
      ),
      floatingActionButton: !afficherFormulaire
          ? FloatingActionButton.extended(
              onPressed: () => basculerVue(),
              icon: const Icon(Icons.add),
              label: const Text("Ajouter"),
              backgroundColor: Colors.teal,
            )
          : null,
    );
  }
}
