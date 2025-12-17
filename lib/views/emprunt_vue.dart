import 'package:flutter/material.dart';
import '../controllers/emprunt_controlleur.dart';
import '../models/emprunt_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class EmpruntVue extends StatefulWidget {
  const EmpruntVue({super.key});

  @override
  State<EmpruntVue> createState() => _EmpruntVueState();
}

class _EmpruntVueState extends State<EmpruntVue> {
  //Champs de texte pour le formulaire
  final TextEditingController _documentController = TextEditingController();//id 
  final TextEditingController _searchController = TextEditingController();//champs pour chercher 
  ///ici ili ajoute au date de retour 7 jours a partir de maintenant 
  DateTime _dateRetour = DateTime.now().add(const Duration(days: 7));
  String _motCleRecherche = '';
  bool _afficherFormulaire = false;

  // on a creer une instance avec le controlleur
  final EmpruntControlleur controller = EmpruntControlleur();

  void ajouterEmprunt() async {
    if (_documentController.text.isEmpty) return;

    EmpruntModel emprunt = EmpruntModel(
      idDocument: _documentController.text.trim(),
      dateEmprunt: DateTime.now(),
      dateRetour: _dateRetour,
      rendu: false,/// c est a dire par defaut l emprunt n est pas rendu 
    );
//Appel de la fonction du contrôleur pour ajouter l'emprunt dans Firestore
    await controller.ajouterEmprunt(emprunt);
    _documentController.clear();
    setState(() => _afficherFormulaire = false);
  }

 
  DateTime parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion des Emprunts"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(_afficherFormulaire ? Icons.list : Icons.add),
            tooltip: _afficherFormulaire ? "Voir la liste" : "Ajouter un emprunt",
            onPressed: () {//lorsque je clique sur + il m affiche le formulaire 
              setState(() => _afficherFormulaire = !_afficherFormulaire);
            },
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _afficherFormulaire
            ? _buildFormulaire()
            : Column(
                children: [
                  _buildRecherche(),
                  Expanded(
                    child: StreamBuilder<List<EmpruntModel>>(
                      stream: controller.getTousEmprunts(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text("Erreur: ${snapshot.error}"));
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        // rechercher selon id emprunt
                        final emprunts = snapshot.data
                                ?.where((e) => e.idDocument.contains(_motCleRecherche))
                                .toList() ??
                            [];

                        if (emprunts.isEmpty) {
                          return const Center(child: Text("Aucun emprunt trouvé"));
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: emprunts.length,
                          itemBuilder: (context, index) {
                            final emprunt = emprunts[index];
                            return _buildEmpruntCard(emprunt);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: !_afficherFormulaire
          ? FloatingActionButton.extended(
              onPressed: () => setState(() => _afficherFormulaire = true),
              icon: const Icon(Icons.add),
              label: const Text("Ajouter"),
              backgroundColor: Colors.teal,
            )
          : null,
    );
  }

  // le  Formulaire
  Widget _buildFormulaire() {
    return Center(
      key: const ValueKey(1),
      child: Card(
        //espace a gauche
        margin: const EdgeInsets.all(16),
        //coin arrondi
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        child: Padding(
          //espace dans le champs haut bas droit a gauche tout 16 pixel
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _documentController,
                decoration: const InputDecoration(
                  labelText: "ID du document",
                  prefixIcon: Icon(Icons.book, color: Colors.teal),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    "Date retour: ${_dateRetour.toLocal().toString().split(' ')[0]}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.teal),
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _dateRetour,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) setState(() => _dateRetour = picked);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                //on va appliquer la fonction ajouter une emprunt 
                onPressed: ajouterEmprunt,
                icon: const Icon(Icons.save),
                //la label le champs 
                label: const Text("Enregistrer"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Recherche
  Widget _buildRecherche() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          labelText: "Rechercher par ID de document",
          //icone de recherche
          prefixIcon: const Icon(Icons.search, color: Colors.teal),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              setState(() => _motCleRecherche = '');
            },
          ),
        ),
        onChanged: (v) => setState(() => _motCleRecherche = v.trim()),
      ),
    );
  }

  // dans le buit de cree une carte pour chaque emprunt dans la liste 
  Widget _buildEmpruntCard(EmpruntModel emprunt) {
    return _AnimatedEmpruntCard(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        title: Text("Document: ${emprunt.idDocument}"),
        subtitle: Text(
            "Retour prévu: ${emprunt.dateRetour.toLocal().toString().split(' ')[0]}"),
        trailing: Wrap(
          spacing: 8,
          children: [
            emprunt.rendu
                ? const Icon(Icons.check, color: Colors.green)
                : ElevatedButton(
                    onPressed: () async {
                      if (emprunt.id != null) {
                        await controller.rendreDocument(emprunt.id!);
                        setState(() {});
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("Rendre"),
                  ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                if (emprunt.id != null) {
                  await controller.supprimerEmprunt(emprunt.id!);
                  setState(() {});
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// lorsque je clique sur la carte elle fait zoom automqtique 
class _AnimatedEmpruntCard extends StatefulWidget {
  final Widget child;
  const _AnimatedEmpruntCard({required this.child, super.key});

  @override
  State<_AnimatedEmpruntCard> createState() => _AnimatedEmpruntCardState();
}

class _AnimatedEmpruntCardState extends State<_AnimatedEmpruntCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      child: MouseRegion(
        onEnter: (_) => setState(() => _scale = 1.03),
        onExit: (_) => setState(() => _scale = 1.0),
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 150),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
