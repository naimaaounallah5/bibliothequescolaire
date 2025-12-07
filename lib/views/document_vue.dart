/*import 'package:flutter/material.dart';
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
tooltip: afficherFormulaire ? "Voir la liste" : "Ajouter un document",
onPressed: basculerVue,
),
],
),
body: AnimatedSwitcher(
duration: const Duration(milliseconds: 300),
transitionBuilder: (child, anim) =>
FadeTransition(opacity: anim, child: child),
child: afficherFormulaire
? Card(
key: const ValueKey(1),
elevation: 4,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12)),
margin: const EdgeInsets.all(12),
child: Padding(
padding: const EdgeInsets.all(16.0),
child: DocumentFormVue(
onSave: basculerVue, // revenir à la liste après sauvegarde
),
),
)
: Card(
key: const ValueKey(2),
elevation: 3,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12)),
margin: const EdgeInsets.all(12),
child: Padding(
padding: const EdgeInsets.all(8.0),
child: DocumentListVue(),
),
),
),
floatingActionButton: !afficherFormulaire
? FloatingActionButton.extended(
onPressed: basculerVue,
backgroundColor: Colors.teal,
icon: const Icon(Icons.add),
label: const Text("Ajouter"),
)
: null,
);
}
}
*/
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
