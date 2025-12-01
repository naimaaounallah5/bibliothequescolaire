
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'views/emprunt_vue.dart';
import 'views/utilisateur_vue.dart';
import 'views/document_vue.dart'; // Assure-toi que le fichier s'appelle document_vue.dart

Future<void> connexionTest() async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: 'test@gmail.com',
      password: '123456',
    );
    print("Connecté : ${userCredential.user?.uid}");
  } catch (e) {
    print("Erreur de connexion : $e");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await connexionTest();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion Bibliothèque',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: const Text("Gestion Bibliothèque")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text("Gérer les utilisateurs"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UtilisateurVue()),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text("Gérer les emprunts"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EmpruntVue()),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text("Gérer les documents"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>const DocumentVue()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
