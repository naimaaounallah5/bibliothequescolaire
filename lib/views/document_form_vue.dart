import 'package:flutter/material.dart';
import '../controllers/document_controller.dart';
import '../models/document_model.dart';
// c est le page de formulaire 
///elle contient les champs a remplir 
class DocumentFormVue extends StatefulWidget {
  final DocumentModel? document;// Document existant à modifier (ou null si nouveau)
  final VoidCallback? onSave;// Fonction callback après sauvegarde

  const DocumentFormVue({super.key, this.document, this.onSave});

  @override
  State<DocumentFormVue> createState() => _DocumentFormVueState();
}

class _DocumentFormVueState extends State<DocumentFormVue> {
  //pour valider les champs de formulaire 
  final _formKey = GlobalKey<FormState>();
  final DocumentController ctrl = DocumentController();
//je intialise le variable apres
//les champs de texte de formulaire 
  late TextEditingController titleCtrl;
  late TextEditingController authorCtrl;
  late TextEditingController categoryCtrl;
  late TextEditingController yearCtrl;
  bool available = true;
///pour preparer les champs pour ajouter ou modifier dans le formulaire 
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
    //si tout les champs obligatoire  de formulaire sont remplis 
    if (!_formKey.currentState!.validate()) return;
//Créer un objet DocumentModel
    final r = DocumentModel(
      id: widget.document?.id ?? "",
      title: titleCtrl.text.trim(),
      author: authorCtrl.text.trim(),
      category: categoryCtrl.text.trim(),
      year: int.tryParse(yearCtrl.text.trim()) ?? 0,
      available: available,
    );

    if (widget.document == null) await ctrl.addDocument(r);
    //pour ajouter nouveaux documents 
    else await ctrl.updateDocument(r);

    widget.onSave?.call();
  }
//Il prend n’importe quel widget de champ (field) et le place dans une carte (Card).

//La carte a une ombre légère (elevation: 2), des bords arrondis, et une couleur de fond claire.

//À l’intérieur, il y a un padding pour que le champ ne touche pas directement les bords.
  Widget buildField({required Widget field}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.teal.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: field,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            buildField(
              field: TextFormField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: "Titre",
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.book, color: Colors.teal),
                ),
                validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
              ),
            ),
            //champs de texte pour auteur
            buildField(
              field: TextFormField(
                controller: authorCtrl,
                decoration: const InputDecoration(
                  labelText: "Auteur",
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.person, color: Colors.teal),
                ),
              ),
            ),
            //champs de texte pour categorie
            buildField(
              field: TextFormField(
                controller: categoryCtrl,
                decoration: const InputDecoration(
                  labelText: "Catégorie",
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.category, color: Colors.teal),
                ),
              ),
            ),
            //champs de texte pour l anneée
            buildField(
              field: TextFormField(
                controller: yearCtrl,
                decoration: const InputDecoration(
                  labelText: "Année",
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.calendar_today, color: Colors.teal),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            //diponible ou non true ou false 
            SwitchListTile(
              value: available,
              onChanged: (v) => setState(() => available = v),
              title: const Text("Disponible"),
              activeColor: Colors.teal,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  widget.document == null ? "Ajouter" : "Enregistrer",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
