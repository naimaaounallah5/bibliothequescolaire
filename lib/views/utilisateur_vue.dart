import 'package:flutter/material.dart';
import '../controllers/utilisateur_controlleur.dart';
import '../models/utilisateur_model.dart';

class UtilisateurVue extends StatefulWidget {
  const UtilisateurVue({super.key});

  @override
  State<UtilisateurVue> createState() => _UtilisateurVueState();
}

class _UtilisateurVueState extends State<UtilisateurVue> {
  final UtilisateurControlleur controlleur = UtilisateurControlleur();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mdpController = TextEditingController();
  String _roleSelectionne = 'apprenant';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestion des Utilisateurs")),
      body: Column(
        children: [
          // Formulaire création utilisateur
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: _mdpController,
                  decoration: InputDecoration(labelText: "Mot de passe"),
                  obscureText: true,
                ),
                DropdownButton<String>(
                  value: _roleSelectionne,
                  items: [
                    DropdownMenuItem(value: 'apprenant', child: Text('Apprenant')),
                    DropdownMenuItem(value: 'admin', child: Text('Administrateur')),
                    DropdownMenuItem(value: 'bibliothecaire', child: Text('Bibliothécaire')),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _roleSelectionne = val!;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_emailController.text.isNotEmpty && _mdpController.text.isNotEmpty) {
                      await controlleur.creerUtilisateur(
                          _emailController.text.trim(),
                          _mdpController.text.trim(),
                          _roleSelectionne);
                      _emailController.clear();
                      _mdpController.clear();
                      setState(() {});
                    }
                  },
                  child: Text("Ajouter Utilisateur"),
                ),
              ],
            ),
          ),
          Divider(),

          // Liste des utilisateurs
          Expanded(
            child: StreamBuilder<List<Utilisateur>>(
              stream: controlleur.getTousUtilisateurs(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                final utilisateurs = snapshot.data!;
                if (utilisateurs.isEmpty) return Center(child: Text("Aucun utilisateur"));

                return ListView.builder(
                  itemCount: utilisateurs.length,
                  itemBuilder: (context, index) {
                    final u = utilisateurs[index];
                    return ListTile(
                      title: Text(u.email),
                      subtitle: Text("Rôle: ${u.role}"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await controlleur.supprimerUtilisateur(u.id);
                          setState(() {});
                        },
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
