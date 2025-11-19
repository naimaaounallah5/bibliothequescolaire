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
    final Stream<List<DocumentModel>> stream =
        searchTerm.isEmpty ? ctrl.allDocuments() : ctrl.search(searchTerm);

    return Scaffold(
      appBar: AppBar(title: const Text("Catalogue de documents")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(labelText: "Rechercher par titre..."),
              onChanged: (v) => setState(() => searchTerm = v.trim()),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<DocumentModel>>(
              stream: stream,
              builder: (context, snap) {
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final list = snap.data!;

                if (list.isEmpty) return const Center(child: Text("Aucun document trouvé"));

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final r = list[i];
                    return ListTile(
                      title: Text(r.title),
                      subtitle: Text("${r.author} • ${r.category} • ${r.year}"),
                      trailing: PopupMenuButton(
                        itemBuilder: (_) => [
                          const PopupMenuItem(value: "edit", child: Text("Modifier")),
                          const PopupMenuItem(value: "delete", child: Text("Supprimer")),
                        ],
                        onSelected: (v) async {
                          if (v == "edit") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => DocumentFormVue(document: r)),
                            );
                          } else if (v == "delete") {
                            if (r.id.isNotEmpty) await ctrl.deleteDocument(r.id);
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
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const DocumentFormVue()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
