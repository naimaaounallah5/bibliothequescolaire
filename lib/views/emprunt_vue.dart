import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmpruntVue extends StatefulWidget {
  const EmpruntVue({super.key});

  @override
  State<EmpruntVue> createState() => _EmpruntVueState();
}

class _EmpruntVueState extends State<EmpruntVue> {
  final TextEditingController _documentController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  DateTime _dateRetour = DateTime.now().add(const Duration(days: 7));
  String _motCleRecherche = '';

  final CollectionReference empruntCollection =
      FirebaseFirestore.instance.collection('emprunts');

  // Conversion sécurisée des dates
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
      ),
      body: Column(
        children: [
          // Recherche
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Rechercher par ID de document",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
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
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _documentController,
                      decoration: const InputDecoration(
                          labelText: "ID du document"),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                            "Date retour: ${_dateRetour.toLocal().toString().split(' ')[0]}"),
                        IconButton(
                          icon: const Icon(Icons.calendar_today,
                              color: Colors.teal),
                          onPressed: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _dateRetour,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 365)),
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
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          minimumSize: const Size.fromHeight(40)),
                      onPressed: () async {
                        if (_documentController.text.isNotEmpty) {
                          await empruntCollection.add({
                            'idDocument': _documentController.text.trim(),
                            'dateEmprunt': Timestamp.fromDate(DateTime.now()),
                            'dateRetour': Timestamp.fromDate(_dateRetour),
                            'rendu': false,
                          });
                          _documentController.clear();
                          setState(() {});
                        }
                      },
                      child: const Text("Ajouter Emprunt"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(),

          // Liste des emprunts
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _motCleRecherche.isEmpty
                  ? empruntCollection.snapshots()
                  : empruntCollection
                      .where('idDocument',
                          isGreaterThanOrEqualTo: _motCleRecherche)
                      .where('idDocument',
                          isLessThanOrEqualTo: _motCleRecherche + '\uf8ff')
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Erreur: ${snapshot.error}"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final emprunts = snapshot.data?.docs ?? [];
                if (emprunts.isEmpty) {
                  return const Center(child: Text("Aucun emprunt trouvé"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: emprunts.length,
                  itemBuilder: (context, index) {
                    final doc = emprunts[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final rendu = data['rendu'] ?? false;
                    final dateRetour = parseDate(data['dateRetour']);

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 4),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        title: Text("Document: ${data['idDocument']}"),
                        subtitle: Text(
                            "Retour prévu: ${dateRetour.toLocal().toString().split(' ')[0]}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            rendu
                                ? const Icon(Icons.check, color: Colors.green)
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green),
                                    onPressed: () async {
                                      await empruntCollection
                                          .doc(doc.id)
                                          .update({'rendu': true});
                                      setState(() {});
                                    },
                                    child: const Text("Rendre"),
                                  ),
                            const SizedBox(width: 5),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () async {
                                DateTime nouvelleDate = await showDatePicker(
                                      context: context,
                                      initialDate: dateRetour,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 365)),
                                    ) ??
                                    dateRetour;
                                await empruntCollection.doc(doc.id).update({
                                  'dateRetour': Timestamp.fromDate(nouvelleDate)
                                });
                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await empruntCollection.doc(doc.id).delete();
                                setState(() {});
                              },
                            ),
                          ],
                        ),
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
