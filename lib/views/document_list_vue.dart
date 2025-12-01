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
      appBar: AppBar(title: const Text("Catalogue de documents")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Rechercher par titre...",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => searchTerm = v.trim()),
            ),
          ),
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
                    return ListTile(
                      title: Text(r.title),
                      subtitle: Text("${r.author} • ${r.category} • ${r.year}"),
                      trailing: PopupMenuButton<String>(
                        itemBuilder: (_) => [
                          const PopupMenuItem(value: "edit", child: Text("Modifier")),
                          const PopupMenuItem(value: "delete", child: Text("Supprimer")),
                        ],
                        onSelected: (v) async {
                          if (v == "edit") {
                            final updatedDoc = await Navigator.push<DocumentModel>(
                              context,
                              MaterialPageRoute(builder: (_) => DocumentFormVue(document: r)),
                            );
                            // Firestore will automatically update the stream
                          } else if (v == "delete") {
                            await ctrl.deleteDocument(r.id);
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newDoc = await Navigator.push<DocumentModel>(
            context,
            MaterialPageRoute(builder: (_) => const DocumentFormVue()),
          );
          // Firestore stream will automatically update the list
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
