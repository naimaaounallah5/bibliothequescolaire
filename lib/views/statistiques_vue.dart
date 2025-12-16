import 'package:flutter/material.dart';
import '../models/emprunt_model.dart';
import '../models/document_model.dart';
import '../services/firestore_service.dart';

class StatistiquesPage extends StatefulWidget {
const StatistiquesPage({super.key});

@override
State<StatistiquesPage> createState() => _StatistiquesPageState();
}

class _StatistiquesPageState extends State<StatistiquesPage> {
final FirestoreService _firestoreService = FirestoreService();

List<EmpruntModel> emprunts = [];
List<DocumentModel> documents = [];

Map<String, int> livresPlusEmpruntes = {};
Map<String, int> documentsParCategorie = {};

bool isLoading = true;

@override
void initState() {
super.initState();
loadData();
}

Future<void> loadData() async {
emprunts = await _firestoreService.getEmprunts();
documents = await _firestoreService.getDocuments();


// Livres les plus empruntés
livresPlusEmpruntes.clear();
for (var emprunt in emprunts) {
  String titre = emprunt.idDocument;
  if (titre.isNotEmpty) {
    livresPlusEmpruntes[titre] = (livresPlusEmpruntes[titre] ?? 0) + 1;
  }
}

// Documents par catégorie
documentsParCategorie.clear();
for (var doc in documents) {
  if (doc.category.isNotEmpty) {
    documentsParCategorie[doc.category] =
        (documentsParCategorie[doc.category] ?? 0) + 1;
  }
}

setState(() => isLoading = false);


}

String getLivreLePlusEmprunte() {
if (livresPlusEmpruntes.isEmpty) return "Aucun livre emprunté";
final maxEntry = livresPlusEmpruntes.entries.reduce(
(a, b) => a.value >= b.value ? a : b,
);
return '${maxEntry.key} → ${maxEntry.value} emprunts';
}

Widget buildCard({required IconData icon, required String title, required Widget child, required List<Color> gradientColors}) {
return Container(
margin: const EdgeInsets.symmetric(vertical: 10),
decoration: BoxDecoration(
gradient: LinearGradient(colors: gradientColors),
borderRadius: BorderRadius.circular(16),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.2),
blurRadius: 6,
offset: const Offset(0, 4),
)
],
),
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Icon(icon, color: Colors.white, size: 28),
const SizedBox(width: 12),
Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
],
),
const SizedBox(height: 12),
child,
],
),
),
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Statistiques"),
backgroundColor: Colors.teal,
),
body: isLoading
? const Center(child: CircularProgressIndicator())
: SingleChildScrollView(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// Livres les plus empruntés
buildCard(
icon: Icons.menu_book,
title: "Livres les plus empruntés",
gradientColors: [Colors.teal, Colors.cyan],
child: livresPlusEmpruntes.isEmpty
? const Text("Aucun livre emprunté", style: TextStyle(color: Colors.white))
: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: livresPlusEmpruntes.entries
.map((e) => Text('${e.key} → ${e.value} emprunts',
style: const TextStyle(color: Colors.white, fontSize: 16)))
.toList(),
),
),


              // Livre le plus emprunté avec badge
              buildCard(
                icon: Icons.star,
                title: "Livre le plus emprunté",
                gradientColors: [Colors.orange, Colors.deepOrange],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(getLivreLePlusEmprunte(), style: const TextStyle(color: Colors.white, fontSize: 16)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Text("Top", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),

              // Documents par catégorie
              buildCard(
                icon: Icons.category,
                title: "Documents par catégorie",
                gradientColors: [Colors.purple, Colors.deepPurple],
                child: documentsParCategorie.isEmpty
                    ? const Text("Aucun document", style: TextStyle(color: Colors.white))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: documentsParCategorie.entries
                            .map((e) => Text('${e.key} → ${e.value} documents',
                                style: const TextStyle(color: Colors.white, fontSize: 16)))
                            .toList(),
                      ),
              ),

              // Totaux
              buildCard(
                icon: Icons.data_usage,
                title: "Totaux",
                gradientColors: [Colors.green, Colors.lightGreen],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total emprunts : ${emprunts.length}', style: const TextStyle(color: Colors.white, fontSize: 16)),
                    Text('Total documents : ${documents.length}', style: const TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        ),
);


}
}
