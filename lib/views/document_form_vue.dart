import 'package:flutter/material.dart';
import '../controllers/document_controller.dart';
import '../models/document_model.dart';

class DocumentFormVue extends StatefulWidget {
  final DocumentModel? document;
  final VoidCallback? onSave; // paramètre optionnel

  const DocumentFormVue({super.key, this.document, this.onSave});

  @override
  State<DocumentFormVue> createState() => _DocumentFormVueState();
}

class _DocumentFormVueState extends State<DocumentFormVue> {
  final _formKey = GlobalKey<FormState>();
  final DocumentController ctrl = DocumentController();

  late TextEditingController titleCtrl;
  late TextEditingController authorCtrl;
  late TextEditingController categoryCtrl;
  late TextEditingController yearCtrl;
  bool available = true;

  @override
  void initState() {
    super.initState();
    final r = widget.document;
    titleCtrl = TextEditingController(text: r?.title ?? "");
    authorCtrl = TextEditingController(text: r?.author ?? "");
    categoryCtrl = TextEditingController(text: r?.category ?? "");
    yearCtrl = TextEditingController(text: r?.year.toString() ?? "");
    available = r?.available ?? true;
  }

  void save() async {
    if (!_formKey.currentState!.validate()) return;

    final r = DocumentModel(
      id: widget.document?.id ?? "",
      title: titleCtrl.text.trim(),
      author: authorCtrl.text.trim(),
      category: categoryCtrl.text.trim(),
      year: int.tryParse(yearCtrl.text.trim()) ?? 0,
      available: available,
    );

    if (widget.document == null) {
      await ctrl.addDocument(r);
    } else {
      await ctrl.updateDocument(r);
    }

    if (widget.onSave != null) widget.onSave!();

    Navigator.pop(context, r);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document == null ? "Ajouter Document" : "Modifier Document"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Titre
              TextFormField(
                controller: titleCtrl,
                decoration: InputDecoration(
                  labelText: "Titre",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.book),
                ),
                validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
              ),
              const SizedBox(height: 12),
              // Auteur
              TextFormField(
                controller: authorCtrl,
                decoration: InputDecoration(
                  labelText: "Auteur",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              // Catégorie
              TextFormField(
                controller: categoryCtrl,
                decoration: InputDecoration(
                  labelText: "Catégorie",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.category),
                ),
              ),
              const SizedBox(height: 12),
              // Année
              TextFormField(
                controller: yearCtrl,
                decoration: InputDecoration(
                  labelText: "Année",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              // Disponible
              SwitchListTile(
                value: available,
                onChanged: (v) => setState(() => available = v),
                title: const Text("Disponible"),
                activeColor: Colors.teal,
              ),
              const SizedBox(height: 12),
              // Bouton Enregistrer
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Enregistrer", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
