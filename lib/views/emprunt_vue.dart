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
bool _afficherFormulaire = false;

final CollectionReference empruntCollection =
FirebaseFirestore.instance.collection('emprunts');

DateTime parseDate(dynamic value) {
if (value is Timestamp) return value.toDate();
if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
return DateTime.now();
}

void ajouterEmprunt() async {
if (_documentController.text.isEmpty) return;
await empruntCollection.add({
'idDocument': _documentController.text.trim(),
'dateEmprunt': Timestamp.fromDate(DateTime.now()),
'dateRetour': Timestamp.fromDate(_dateRetour),
'rendu': false,
});
_documentController.clear();
setState(() => _afficherFormulaire = false);
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
onPressed: () {
setState(() => _afficherFormulaire = !_afficherFormulaire);
},
),
],
),
body: AnimatedSwitcher(
duration: const Duration(milliseconds: 300),
child: _afficherFormulaire
? Center(
key: const ValueKey(1),
child: Card(
margin: const EdgeInsets.all(16),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(20)),
elevation: 8,
child: Padding(
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
onPressed: ajouterEmprunt,
icon: const Icon(Icons.save),
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
)
: Column(
children: [
Padding(
padding: const EdgeInsets.all(8.0),
child: TextField(
controller: _searchController,
decoration: InputDecoration(
labelText: "Rechercher par ID de document",
prefixIcon: const Icon(Icons.search, color: Colors.teal),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
),
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
),
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

                        return _AnimatedEmpruntCard(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            title: Text("Document: ${data['idDocument']}"),
                            subtitle: Text(
                                "Retour prévu: ${dateRetour.toLocal().toString().split(' ')[0]}"),
                            trailing: Wrap(
                              spacing: 8,
                              children: [
                                rendu
                                    ? const Icon(Icons.check, color: Colors.green)
                                    : ElevatedButton(
                                        onPressed: () async {
                                          await empruntCollection
                                              .doc(doc.id)
                                              .update({'rendu': true});
                                          setState(() {});
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green),
                                        child: const Text("Rendre"),
                                      ),
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.orange),
                                  onPressed: () async {
                                    DateTime nouvelleDate = await showDatePicker(
                                          context: context,
                                          initialDate: dateRetour,
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now().add(const Duration(days: 365)),
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
}

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
