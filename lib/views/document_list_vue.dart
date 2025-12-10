/*import 'package:flutter/material.dart';
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

Widget buildSearchField() {
return Card(
elevation: 2,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
child: TextField(
decoration: const InputDecoration(
hintText: "Rechercher par titre...",
border: InputBorder.none,
prefixIcon: Icon(Icons.search, color: Colors.teal),
contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
),
onChanged: (v) => setState(() => searchTerm = v.trim()),
),
);
}

Widget buildDocumentCard(DocumentModel r) {
return Card(
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
elevation: 3,
margin: const EdgeInsets.symmetric(vertical: 6),
child: ListTile(
contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
title: Row(
children: [
const Icon(Icons.book, color: Colors.teal),
const SizedBox(width: 8),
Expanded(child: Text(r.title, style: const TextStyle(fontWeight: FontWeight.bold))),
],
),
subtitle: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const SizedBox(height: 4),
Row(
children: [
const Icon(Icons.person, size: 16, color: Colors.grey),
const SizedBox(width: 4),
Text(r.author),
],
),
const SizedBox(height: 2),
Row(
children: [
const Icon(Icons.category, size: 16, color: Colors.grey),
const SizedBox(width: 4),
Text(r.category),
],
),
const SizedBox(height: 2),
Row(
children: [
const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
const SizedBox(width: 4),
Text(r.year.toString()),
],
),
],
),
trailing: PopupMenuButton<String>(
icon: const Icon(Icons.more_vert, color: Colors.teal),
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
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Catalogue de documents"),
backgroundColor: Colors.teal,
),
body: Padding(
padding: const EdgeInsets.all(16),
child: Column(
children: [
buildSearchField(),
const SizedBox(height: 12),
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
                itemBuilder: (_, i) => buildDocumentCard(filtered[i]),
              );
            },
          ),
        ),
      ],
    ),
  ),
  floatingActionButton: FloatingActionButton.extended(
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
    icon: const Icon(Icons.add),
    label: const Text("Ajouter"),
  ),
);


}
}
*/
//code de liste vue dart
import 'package:flutter/material.dart';
import '../controllers/document_controller.dart';
import '../models/document_model.dart';

class DocumentListVue extends StatefulWidget {
  final Function(DocumentModel)? onEdit;
  const DocumentListVue({super.key, this.onEdit});

  @override
  State<DocumentListVue> createState() => _DocumentListVueState();
}

class _DocumentListVueState extends State<DocumentListVue> {
  final DocumentController ctrl = DocumentController();
  String searchTerm = "";

  // Champ de recherche stylisé
  Widget buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Rechercher par titre...",
        prefixIcon: const Icon(Icons.search, color: Colors.teal),
        filled: true,
        fillColor: Colors.teal.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (v) => setState(() => searchTerm = v.trim()),
    );
  }

  // Carte stylisée pour chaque document
  Widget buildDocumentCard(DocumentModel r) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shadowColor: Colors.teal.withOpacity(0.3),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.teal.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(6),
              child: const Icon(Icons.book, color: Colors.teal),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                r.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              infoRow(Icons.person, r.author),
              const SizedBox(height: 4),
              infoRow(Icons.category, r.category),
              const SizedBox(height: 4),
              infoRow(Icons.calendar_today, r.year.toString()),
            ],
          ),
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.teal),
          itemBuilder: (_) => const [
            PopupMenuItem(value: "edit", child: Text("Modifier")),
            PopupMenuItem(value: "delete", child: Text("Supprimer")),
          ],
          onSelected: (v) async {
            if (v == "edit" && widget.onEdit != null) widget.onEdit!(r);
            if (v == "delete") {
              await ctrl.deleteDocument(r.id);
              setState(() {});
            }
          },
        ),
      ),
    );
  }

  // Ligne d'info pour sous-titre
  Widget infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: Colors.grey.shade800)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          buildSearchField(),
          const SizedBox(height: 16),
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
                  itemBuilder: (_, i) => buildDocumentCard(filtered[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
