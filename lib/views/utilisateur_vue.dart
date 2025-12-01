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
      appBar: AppBar(
        title: const Text("Gestion des Utilisateurs"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Formulaire création utilisateur
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _mdpController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Mot de passe",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _roleSelectionne,
                      decoration: InputDecoration(
                        labelText: "Rôle",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'apprenant', child: Text('Apprenant')),
                        DropdownMenuItem(value: 'admin', child: Text('Administrateur')),
                        DropdownMenuItem(value: 'bibliothecaire', child: Text('Bibliothécaire')),
                      ],
                      onChanged: (val) => setState(() => _roleSelectionne = val!),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_emailController.text.isNotEmpty && _mdpController.text.isNotEmpty) {
                            await controlleur.creerUtilisateur(
                              _emailController.text.trim(),
                              _mdpController.text.trim(),
                              _roleSelectionne,
                            );
                            _emailController.clear();
                            _mdpController.clear();
                            setState(() {});
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Ajouter Utilisateur", style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            // Liste des utilisateurs
            Expanded(
              child: StreamBuilder<List<Utilisateur>>(
                stream: controlleur.getTousUtilisateurs(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final utilisateurs = snapshot.data!;
                  if (utilisateurs.isEmpty) return const Center(child: Text("Aucun utilisateur"));

                  return ListView.builder(
                    itemCount: utilisateurs.length,
                    itemBuilder: (context, index) {
                      final u = utilisateurs[index];
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                        elevation: 2,
                        child: ListTile(
                          title: Text(u.email),
                          subtitle: Text("Rôle: ${u.role}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await controlleur.supprimerUtilisateur(u.id);
                              setState(() {});
                            },
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
    );
  }
}
