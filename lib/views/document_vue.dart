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
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(afficherFormulaire ? Icons.list : Icons.add),
            onPressed: basculerVue,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: afficherFormulaire
            ? Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: DocumentFormVue(
                    onSave: () {
                      // Après ajout, revenir à la liste
                      basculerVue();
                    },
                  ),
                ),
              )
            : Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DocumentListVue(),
                ),
              ),
      ),
    );
  }
}
