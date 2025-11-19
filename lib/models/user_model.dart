class AppUser {
  final String uid;
  final String email;
  final String role; // 'apprenant_loge', 'apprenant_externe', 'admin'

  AppUser({required this.uid, required this.email, required this.role});
}
