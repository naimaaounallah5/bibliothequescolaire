import 'package:flutter/material.dart';
import '../controllers/document_controller.dart';
import '../models/document_model.dart';

class DocumentFormVue extends StatefulWidget {
  final DocumentModel? document;
  const DocumentFormVue({super.key, this.document});

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
      await ctrl.addDocument(r);  // ajout réel dans Firestore
    } else {
      await ctrl.updateDocument(r);  // modification uniquement si id existe
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.document == null ? "Ajouter" : "Modifier")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: "Titre"),
                validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
              ),
              TextFormField(
                controller: authorCtrl,
                decoration: const InputDecoration(labelText: "Auteur"),
              ),
              TextFormField(
                controller: categoryCtrl,
                decoration: const InputDecoration(labelText: "Catégorie"),
              ),
              TextFormField(
                controller: yearCtrl,
                decoration: const InputDecoration(labelText: "Année"),
                keyboardType: TextInputType.number,
              ),
              SwitchListTile(
                value: available,
                onChanged: (v) => setState(() => available = v),
                title: const Text("Disponible"),
              ),
              ElevatedButton(onPressed: save, child: const Text("Enregistrer"))
            ],
          ),
        ),
      ),
    );
  }
}
