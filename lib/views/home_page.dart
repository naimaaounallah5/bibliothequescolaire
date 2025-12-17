import 'package:flutter/material.dart';
import 'document_vue.dart';
import 'emprunt_vue.dart';
import 'utilisateur_vue.dart';
import 'statistiques_vue.dart';
//cette page c est la page d acceuil et lorsque on clique sur commencer les 4 buttons ils sont affciher 
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  bool showOptions = false;// Détermine si les options (cartes) sont affichées
   // Contrôleur et animations pour l'effet fade + slide des cartes
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // Initialisation du contrôleur d'animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    // Animation de fondu
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }
// Fonction pour afficher/cacher les options avec animation
  void toggleOptions() {
    setState(() {
      showOptions = !showOptions;
      if (showOptions) _controller.forward(); // Animation d'apparition
      else _controller.reverse();// Animation de disparition
    });
  }
// Carte d'une option (Document, Emprunt, Utilisateur, Statistiques)
  Widget _buildOptionCard(String title, IconData icon, Color color, Widget page) {
    return SlideTransition(
      position: _slideAnimation,// animation de glissement
      child: FadeTransition(
        opacity: _fadeAnimation,// animation de fondu
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 6,
          color: color,// couleur de la carte
          child: ListTile(
            leading: Icon(icon, color: Colors.white, size: 32),// icône
            title: Text(title,
                style: const TextStyle(
                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
             // Au clic, navigue vers la page correspondante
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => page),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // libère le contrôleur d'animation
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
        // Image de fond qui remplit tout l'écran
          SizedBox.expand(
            child: Image.asset(
              'assets/library.png',
              fit: BoxFit.cover,
            ),
          ),
          // Overlay sombre pour rendre l ecriture lisible a l ecriture 
          Container(color: Colors.black.withOpacity(0.4)),
           // Contenu principal
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Bibliothèque Scolaire",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "CSFM Library+",
                      style: TextStyle(color: Colors.white70, fontSize: 24),
                    ),
                    const SizedBox(height: 40),
                     // Bouton "Commencer"
                    ElevatedButton(
                      onPressed: toggleOptions,// affiche/cacher les options
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                      ),
                      child: const Text(
                        "Commencer",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (showOptions)
                      Column(
                        children: [
                             // Carte pour accéder à la gestion des documents
                          _buildOptionCard(
                              "Gestion des Documents", Icons.book, Colors.teal, const DocumentVue()),
                         // Carte pour accéder à la gestion des emprunts
                          _buildOptionCard(
                              "Emprunts", Icons.shopping_bag, Colors.deepOrange, const EmpruntVue()),
                         // Carte pour accéder à la gestion des utilisateurs
                          _buildOptionCard(
                              "Utilisateurs", Icons.person, Colors.blueAccent, const UtilisateurVue()),
                            // Carte pour accéder aux statistiques
                          _buildOptionCard(
                              "Statistiques", Icons.bar_chart, Colors.purple, const StatistiquesPage()),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

