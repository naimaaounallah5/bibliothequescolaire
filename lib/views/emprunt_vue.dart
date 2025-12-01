import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- ajouter ceci
import '../controllers/emprunt_controlleur.dart';
import '../models/emprunt_model.dart';


class EmpruntVue extends StatefulWidget {
  const EmpruntVue({super.key});

  @override
  State<EmpruntVue> createState() => _EmpruntVueState();
}

class _EmpruntVueState extends State<EmpruntVue> {
  final EmpruntControlleur controlleur = EmpruntControlleur();
  final TextEditingController _documentController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  DateTime _dateRetour = DateTime.now().add(Duration(days: 7));
  String _motCleRecherche = '';

  @override
  Widget build(BuildContext context) {
    final String idUtilisateur = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(title: Text("Gestion des Emprunts")),
      body: Column(
        children: [
          // Champ de recherche
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Rechercher par ID de document",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _motCleRecherche = _searchController.text.trim();
                    });
                  },
                ),
              ),
            ),
          ),

          // Formulaire ajout emprunt
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _documentController,
                  decoration: InputDecoration(labelText: "ID du document"),
                ),
                Row(
                  children: [
                    Text("Date retour: ${_dateRetour.toLocal().toString().split(' ')[0]}"),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _dateRetour,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() {
                            _dateRetour = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_documentController.text.isNotEmpty && idUtilisateur.isNotEmpty) {
                      final emprunt = EmpruntModel(
                        id: '',
                        idUtilisateur: idUtilisateur,
                        idDocument: _documentController.text.trim(),
                        dateEmprunt: DateTime.now(),
                        dateRetour: _dateRetour,
                      );
                      await controlleur.ajouterEmprunt(emprunt);
                      _documentController.clear();
                      setState(() {});
                    }
                  },
                  child: Text("Ajouter Emprunt"),
                ),
              ],
            ),
          ),
          Divider(),

          // Liste des emprunts
          Expanded(
            child: StreamBuilder<List<EmpruntModel>>(
              stream: _motCleRecherche.isEmpty
                  ? controlleur.getEmpruntsUtilisateur(idUtilisateur)
                  : controlleur.rechercherEmprunt(idUtilisateur, _motCleRecherche),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Erreur: ${snapshot.error}"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final emprunts = snapshot.data ?? [];
                if (emprunts.isEmpty) {
                  return Center(child: Text("Aucun emprunt trouvé"));
                }

                return ListView.builder(
                  itemCount: emprunts.length,
                  itemBuilder: (context, index) {
                    final e = emprunts[index];
                    return ListTile(
                      title: Text("Document: ${e.idDocument}"),
                      subtitle: Text("Retour prévu: ${e.dateRetour.toLocal().toString().split(' ')[0]}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Rendre
                          e.rendu
                              ? Icon(Icons.check, color: Colors.green)
                              : ElevatedButton(
                                  child: Text("Rendre"),
                                  onPressed: () async {
                                    await controlleur.rendreDocument(e.id);
                                    setState(() {});
                                  },
                                ),
                          SizedBox(width: 5),

                          // Modifier
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.orange),
                            onPressed: () async {
                              DateTime nouvelleDate = await showDatePicker(
                                    context: context,
                                    initialDate: e.dateRetour,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(Duration(days: 365)),
                                  ) ??
                                  e.dateRetour;
                              await controlleur.modifierEmprunt(e.id, {'dateRetour': Timestamp.fromDate(nouvelleDate)});
                              setState(() {});
                            },
                          ),

                          // Supprimer
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await controlleur.supprimerEmprunt(e.id);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
