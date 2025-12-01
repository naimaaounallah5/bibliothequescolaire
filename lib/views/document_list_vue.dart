import 'package:flutter/material.dart';
import '../controllers/document_controller.dart';
import '../models/document_model.dart';
import 'document_form_vue.dart';

class DocumentListVue extends StatefulWidget {
  const DocumentListVue({super.key});

  @override
  State<DocumentListVue> createState() => _DocumentListVueState();
}

class _DocumentListVueState extends State<DocumentListVue> {
  final DocumentController ctrl = DocumentController();
  String searchTerm = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catalogue de documents"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Champ de recherche
            TextField(
              decoration: const InputDecoration(
                labelText: "Rechercher par titre...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => searchTerm = v.trim()),
            ),
            const SizedBox(height: 8),
            // Liste des documents
            Expanded(
              child: StreamBuilder<List<DocumentModel>>(
                stream: ctrl.allDocuments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Erreur: ${snapshot.error}"));
                  }

                  final documents = snapshot.data ?? [];
                  final filtered = searchTerm.isEmpty
                      ? documents
                      : documents
                          .where((d) => d.title.toLowerCase().contains(searchTerm.toLowerCase()))
                          .toList();

                  if (filtered.isEmpty) {
                    return const Center(child: Text("Aucun document trouvé"));
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final r = filtered[i];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          title: Text(r.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("${r.author} • ${r.category} • ${r.year}"),
                          trailing: PopupMenuButton<String>(
                            itemBuilder: (_) => const [
                              PopupMenuItem(value: "edit", child: Text("Modifier")),
                              PopupMenuItem(value: "delete", child: Text("Supprimer")),
                            ],
                            onSelected: (v) async {
                              if (v == "edit") {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DocumentFormVue(
                                      document: r,
                                      onSave: () => setState(() {}),
                                    ),
                                  ),
                                );
                              } else if (v == "delete") {
                                await ctrl.deleteDocument(r.id);
                              }
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DocumentFormVue(
                onSave: () => setState(() {}),
              ),
            ),
          );
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
