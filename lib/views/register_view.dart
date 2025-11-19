import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'home_view.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController _authController = AuthController();
  String selectedRole = 'apprenant_loge';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
              SizedBox(height: 10),
              TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Mot de passe'), obscureText: true),
              SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedRole,
                items: [
                  DropdownMenuItem(value: 'apprenant_loge', child: Text('Apprenant logé')),
                  DropdownMenuItem(value: 'apprenant_externe', child: Text('Apprenant externe')),
                  DropdownMenuItem(value: 'admin', child: Text('Administrateur / Bibliothécaire')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  var user = await _authController.register(emailController.text, passwordController.text, selectedRole);
                  if (user != null) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => HomeView(user: user)));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur inscription')));
                  }
                },
                child: Text('S\'inscrire'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
