/*import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'views/utilisateur_vue.dart';
import 'views/emprunt_vue.dart';
import 'views/document_vue.dart';
//new
import 'views/statistiques_vue.dart';

//code main
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion Bibliothèque',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size(200, 50),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestion Bibliothèque")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UtilisateurVue()),
                );
              },
              child: const Text("Gérer les utilisateurs"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EmpruntVue()),
                );
              },
              child: const Text("Gérer les emprunts"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DocumentVue()),
                );
              },
              child: const Text("Gérer les documents"),
            ),
            ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const StatistiquesPage()),
          );
        },
        child: const Text("Gérer les statistiques"),
      ),
          ],
          
        ),
        
        
      ),
    );
  }
  
}
*/
/*newnnew
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'views/utilisateur_vue.dart';
import 'views/emprunt_vue.dart';
import 'views/document_vue.dart';
import 'views/statistiques_vue.dart';

Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
options: DefaultFirebaseOptions.currentPlatform,
);
runApp(const MyApp());
}

class MyApp extends StatelessWidget {
const MyApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Gestion Bibliothèque',
debugShowCheckedModeBanner: false,
theme: ThemeData(
primarySwatch: Colors.teal,
scaffoldBackgroundColor: Colors.grey[100],
),
home: const HomePage(),
);
}
}

class HomePage extends StatelessWidget {
const HomePage({super.key});

Widget dashboardCard({
required BuildContext context,
required String titre,
required IconData icon,
required Color couleur,
required Widget page,
}) {
return _AnimatedCard(
couleur: couleur,
child: InkWell(
borderRadius: BorderRadius.circular(20),
onTap: () {
Navigator.push(context, MaterialPageRoute(builder: (_) => page));
},
child: Padding(
padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(icon, size: 50, color: Colors.white),
const SizedBox(height: 16),
Text(
titre,
textAlign: TextAlign.center,
style: const TextStyle(
color: Colors.white,
fontSize: 18,
fontWeight: FontWeight.bold),
),
],
),
),
),
);
}

@override
Widget build(BuildContext context) {
final List<Map<String, dynamic>> items = [
{
"titre": "Utilisateurs",
"icon": Icons.person,
"couleur": Colors.teal,
"page": const UtilisateurVue()
},
{
"titre": "Emprunts",
"icon": Icons.book,
"couleur": Colors.deepOrange,
"page": const EmpruntVue()
},
{
"titre": "Documents",
"icon": Icons.library_books,
"couleur": Colors.blue,
"page": const DocumentVue()
},
{
"titre": "Statistiques",
"icon": Icons.bar_chart,
"couleur": Colors.green,
"page": const StatistiquesPage()
},
];


return Scaffold(
  body: Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          return dashboardCard(
            context: context,
            titre: item['titre'],
            icon: item['icon'],
            couleur: item['couleur'],
            page: item['page'],
          );
        },
      ),
    ),
  ),
);


}
}

class _AnimatedCard extends StatefulWidget {
final Widget child;
final Color couleur;
const _AnimatedCard({required this.child, required this.couleur, super.key});

@override
State<_AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<_AnimatedCard> {
double _scale = 1.0;

@override
Widget build(BuildContext context) {
return GestureDetector(
onTapDown: (_) => setState(() => _scale = 0.95),
onTapUp: (_) => setState(() => _scale = 1.0),
onTapCancel: () => setState(() => _scale = 1.0),
child: MouseRegion(
onEnter: (_) => setState(() => _scale = 1.05),
onExit: (_) => setState(() => _scale = 1.0),
child: AnimatedScale(
scale: _scale,
duration: const Duration(milliseconds: 150),
child: Card(
elevation: 8,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
color: widget.couleur,
child: widget.child,
),
),
),
);
}
}
*/
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'views/utilisateur_vue.dart';
import 'views/emprunt_vue.dart';
import 'views/document_vue.dart';
import 'views/statistiques_vue.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bibliothèque Scolaire CSFM Library+',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const AccueilPage(),
    );
  }
}

// ---------------- Page d'accueil ----------------
class AccueilPage extends StatelessWidget {
  const AccueilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/library.png', height: 200),
                const SizedBox(height: 24),
                const Text(
                  "Bibliothèque Scolaire\nCSFM Library+",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DashboardPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    "Commencer",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- Dashboard ----------------
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Widget dashboardCard({
    required BuildContext context,
    required String titre,
    required IconData icon,
    required Color couleur,
    required Widget page,
  }) {
    return _AnimatedCard(
      couleur: couleur,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              const SizedBox(height: 16),
              Text(
                titre,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        "titre": "Utilisateurs",
        "icon": Icons.person,
        "couleur": Colors.teal,
        "page": const UtilisateurVue()
      },
      {
        "titre": "Emprunts",
        "icon": Icons.book,
        "couleur": Colors.deepOrange,
        "page": const EmpruntVue()
      },
      {
        "titre": "Documents",
        "icon": Icons.library_books,
        "couleur": Colors.blue,
        "page": const DocumentVue()
      },
      {
        "titre": "Statistiques",
        "icon": Icons.bar_chart,
        "couleur": Colors.green,
        "page": const StatistiquesPage()
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return dashboardCard(
                context: context,
                titre: item['titre'],
                icon: item['icon'],
                couleur: item['couleur'],
                page: item['page'],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AnimatedCard extends StatefulWidget {
  final Widget child;
  final Color couleur;
  const _AnimatedCard({required this.child, required this.couleur, super.key});

  @override
  State<_AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<_AnimatedCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      child: MouseRegion(
        onEnter: (_) => setState(() => _scale = 1.05),
        onExit: (_) => setState(() => _scale = 1.0),
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 150),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: widget.couleur,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
