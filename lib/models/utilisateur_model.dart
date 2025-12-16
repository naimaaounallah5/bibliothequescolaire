class Utilisateur {
  String id;
  String email;
  String role; //  cest le role de 'apprenant', 'admin', 'bibliothecaire'

  Utilisateur({required this.id, required this.email, required this.role});

  factory Utilisateur.fromMap(String id, Map<String, dynamic> data) {
    return Utilisateur(
      id: id,
      email: data['email'] ?? '',
      role: data['role'] ?? 'apprenant',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'role': role,
    };
  }
}
