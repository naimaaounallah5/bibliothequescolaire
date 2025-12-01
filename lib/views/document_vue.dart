import 'package:flutter/material.dart';
import 'document_list_vue.dart';
import 'document_form_vue.dart';

class DocumentVue extends StatefulWidget {
  const DocumentVue({super.key});

  @override
  State<DocumentVue> createState() => _DocumentVueState();
}

class _DocumentVueState extends State<DocumentVue> {
  bool afficherFormulaire = false; // false = liste, true = formulaire

  void basculerVue() {
    setState(() {
      afficherFormulaire = !afficherFormulaire;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Documents'),
        actions: [
          IconButton(
            icon: Icon(afficherFormulaire ? Icons.list : Icons.add),
            onPressed: basculerVue,
          )
        ],
      ),
      body: afficherFormulaire
          ? DocumentFormVue(
              onSave: () {
                // Après ajout, revenir à la liste
                basculerVue();
              },
            )
          : DocumentListVue(),
    );
  }
}
