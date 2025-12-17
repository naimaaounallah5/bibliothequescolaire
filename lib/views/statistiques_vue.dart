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
  // Service pour interagir avec Firestore
final FirestoreService _firestoreService = FirestoreService();
// Listes pour stocker les emprunts et documents récupérés
List<EmpruntModel> emprunts = [];
List<DocumentModel> documents = [];
// Statistiques dérivées
Map<String, int> livresPlusEmpruntes = {};// compteur par titre
Map<String, int> documentsParCategorie = {}; // compteur par catégorie

bool isLoading = true; // indicateur de chargement

@override
void initState() {
super.initState();
loadData();// Charger les données au démarrage
}
 // Fonction pour récupérer et calculer les statistiques
Future<void> loadData() async {
emprunts = await _firestoreService.getEmprunts();
documents = await _firestoreService.getDocuments();


// Livres les plus empruntés
livresPlusEmpruntes.clear();
for (var emprunt in emprunts) {
  String titre = emprunt.idDocument;
  if (titre.isNotEmpty) {
      // Ajouter 1 au compteur si déjà présent, sinon initialiser à 1
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

setState(() => isLoading = false);// arrêter le loader


}
// Retourne le livre le plus emprunté sous forme de texte
String getLivreLePlusEmprunte() {
if (livresPlusEmpruntes.isEmpty) return "Aucun livre emprunté";
final maxEntry = livresPlusEmpruntes.entries.reduce(
(a, b) => a.value >= b.value ? a : b,
);
return '${maxEntry.key} → ${maxEntry.value} emprunts';
}
// Fonction pour construire une "card" stylisée avec gradient et icône
Widget buildCard({required IconData icon, required String title, required Widget child, required List<Color> gradientColors}) {
return Container(
margin: const EdgeInsets.symmetric(vertical: 10),
decoration: BoxDecoration(
gradient: LinearGradient(colors: gradientColors),// couleur dégradée
borderRadius: BorderRadius.circular(16),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.2),
blurRadius: 6,
offset: const Offset(0, 4),
)
],
),

// Padding autour de la carte pour donner de l'espace intérieur
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,// Aligne tout à gauche
children: [
   // Ligne contenant l'icône et le titre de la carte
Row(
children: [
Icon(icon, color: Colors.white, size: 28),// Icône en haut à gauche
const SizedBox(width: 12),// Espacement entre icône et texte
Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
],
),
const SizedBox(height: 12), // Espacement vertical
child,
],
),
),
);
}

// Build du widget principal
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Statistiques"),// Titre de la page
backgroundColor: Colors.teal,
),
body: isLoading
// Si les données ne sont pas encore chargées, afficher un loader
? const Center(child: CircularProgressIndicator())
: SingleChildScrollView(
padding: const EdgeInsets.all(16),// Espacement autour de la colonne
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

//Carte du livre le plus emprunté avec badge "Top"
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
