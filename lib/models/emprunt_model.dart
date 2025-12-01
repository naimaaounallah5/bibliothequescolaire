import 'package:cloud_firestore/cloud_firestore.dart';

class EmpruntModel {
  final String id;
  final String idUtilisateur;
  final String idDocument;
  final DateTime dateEmprunt;
  final DateTime dateRetour;
  final bool rendu;

  EmpruntModel({
    required this.id,
    required this.idUtilisateur,
    required this.idDocument,
    required this.dateEmprunt,
    required this.dateRetour,
    this.rendu = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'idUtilisateur': idUtilisateur,
      'idDocument': idDocument,
      'dateEmprunt': Timestamp.fromDate(dateEmprunt),
      'dateRetour': Timestamp.fromDate(dateRetour),
      'rendu': rendu,
    };
  }

  factory EmpruntModel.fromMap(String id, Map<String, dynamic> map) {
    DateTime parseDate(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      } else if (value is String) {
        return DateTime.parse(value);
      } else {
        throw Exception("Impossible de parser la date: $value");
      }
    }

    return EmpruntModel(
      id: id,
      idUtilisateur: map['idUtilisateur'] ?? '',
      idDocument: map['idDocument'] ?? '',
      dateEmprunt: parseDate(map['dateEmprunt']),
      dateRetour: parseDate(map['dateRetour']),
      rendu: map['rendu'] ?? false,
    );
  }
}
