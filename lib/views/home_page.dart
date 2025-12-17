import 'package:flutter/material.dart';
import 'document_vue.dart';
import 'emprunt_vue.dart';
import 'utilisateur_vue.dart';
import 'statistiques_vue.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  bool showOptions = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void toggleOptions() {
    setState(() {
      showOptions = !showOptions;
      if (showOptions) _controller.forward();
      else _controller.reverse();
    });
  }

  Widget _buildOptionCard(String title, IconData icon, Color color, Widget page) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 6,
          color: color,
          child: ListTile(
            leading: Icon(icon, color: Colors.white, size: 32),
            title: Text(title,
                style: const TextStyle(
                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image de fond
          SizedBox.expand(
            child: Image.asset(
              'assets/library.png',
              fit: BoxFit.cover,
            ),
          ),
          // Overlay sombre
          Container(color: Colors.black.withOpacity(0.4)),
          // Contenu
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
                    ElevatedButton(
                      onPressed: toggleOptions,
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
                          _buildOptionCard(
                              "Gestion des Documents", Icons.book, Colors.teal, const DocumentVue()),
                          _buildOptionCard(
                              "Emprunts", Icons.shopping_bag, Colors.deepOrange, const EmpruntVue()),
                          _buildOptionCard(
                              "Utilisateurs", Icons.person, Colors.blueAccent, const UtilisateurVue()),
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

