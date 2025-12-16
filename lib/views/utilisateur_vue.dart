/*import 'package:flutter/material.dart';
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
bool _afficherFormulaire = false;

void ajouterUtilisateur() async {
if (_emailController.text.isEmpty || _mdpController.text.isEmpty) return;
await controlleur.creerUtilisateur(
_emailController.text.trim(),
_mdpController.text.trim(),
_roleSelectionne,
);
_emailController.clear();
_mdpController.clear();
setState(() => _afficherFormulaire = false);
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Gestion des Utilisateurs"),
backgroundColor: Colors.teal,
actions: [
IconButton(
icon: Icon(_afficherFormulaire ? Icons.list : Icons.add),
tooltip: _afficherFormulaire ? "Voir la liste" : "Ajouter un utilisateur",
onPressed: () => setState(() => _afficherFormulaire = !_afficherFormulaire),
)
],
),
body: AnimatedSwitcher(
duration: const Duration(milliseconds: 300),
child: _afficherFormulaire
? Card(
key: const ValueKey(1),
margin: const EdgeInsets.all(12),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
elevation: 6,
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
TextField(
controller: _emailController,
decoration: const InputDecoration(
labelText: "Email",
prefixIcon: Icon(Icons.email, color: Colors.teal),
border: OutlineInputBorder(),
),
),
const SizedBox(height: 12),
TextField(
controller: _mdpController,
obscureText: true,
decoration: const InputDecoration(
labelText: "Mot de passe",
prefixIcon: Icon(Icons.lock, color: Colors.teal),
border: OutlineInputBorder(),
),
),
const SizedBox(height: 12),
DropdownButtonFormField<String>(
value: _roleSelectionne,
decoration: const InputDecoration(
labelText: "Rôle",
prefixIcon: Icon(Icons.person, color: Colors.teal),
border: OutlineInputBorder(),
),
items: const [
DropdownMenuItem(value: 'apprenant', child: Text('Apprenant')),
DropdownMenuItem(value: 'admin', child: Text('Administrateur')),
DropdownMenuItem(value: 'bibliothecaire', child: Text('Bibliothécaire')),
],
onChanged: (val) => setState(() => _roleSelectionne = val!),
),
const SizedBox(height: 16),
ElevatedButton.icon(
onPressed: ajouterUtilisateur,
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
)
: StreamBuilder<List<Utilisateur>>(
stream: controlleur.getTousUtilisateurs(),
builder: (context, snapshot) {
if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
final utilisateurs = snapshot.data!;
if (utilisateurs.isEmpty) return const Center(child: Text("Aucun utilisateur"));

              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: utilisateurs.length,
                itemBuilder: (context, index) {
                  final u = utilisateurs[index];
                  return Card(
                    key: ValueKey(u.id),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      leading: const Icon(Icons.person, color: Colors.teal),
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
*/
import 'package:flutter/material.dart';
import '../controllers/utilisateur_controlleur.dart';
import '../models/utilisateur_model.dart';
import 'document_vue.dart';

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
  bool _afficherFormulaire = false;

  void ajouterUtilisateur() async {
    if (_emailController.text.isEmpty || _mdpController.text.isEmpty) return;

    await controlleur.creerUtilisateur(
      _emailController.text.trim(),
      _mdpController.text.trim(),
      _roleSelectionne,
    );

    _emailController.clear();
    _mdpController.clear();

    // Naviguer vers DocumentVue après l'ajout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DocumentVue()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion des Utilisateurs"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(_afficherFormulaire ? Icons.list : Icons.add),
            tooltip: _afficherFormulaire ? "Voir la liste" : "Ajouter un utilisateur",
            onPressed: () => setState(() => _afficherFormulaire = !_afficherFormulaire),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _afficherFormulaire
            ? Card(
                key: const ValueKey(1),
                margin: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email, color: Colors.teal),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _mdpController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Mot de passe",
                          prefixIcon: Icon(Icons.lock, color: Colors.teal),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _roleSelectionne,
                        decoration: const InputDecoration(
                          labelText: "Rôle",
                          prefixIcon: Icon(Icons.person, color: Colors.teal),
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'apprenant', child: Text('Apprenant')),
                          DropdownMenuItem(value: 'admin', child: Text('Administrateur')),
                          DropdownMenuItem(value: 'bibliothecaire', child: Text('Bibliothécaire')),
                        ],
                        onChanged: (val) => setState(() => _roleSelectionne = val!),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: ajouterUtilisateur,
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
              )
            : StreamBuilder<List<Utilisateur>>(
                stream: controlleur.getTousUtilisateurs(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final utilisateurs = snapshot.data!;
                  if (utilisateurs.isEmpty) return const Center(child: Text("Aucun utilisateur"));

                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: utilisateurs.length,
                    itemBuilder: (context, index) {
                      final u = utilisateurs[index];
                      return Card(
                        key: ValueKey(u.id),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          leading: const Icon(Icons.person, color: Colors.teal),
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
