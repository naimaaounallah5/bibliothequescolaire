import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'register_view.dart';
import 'home_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController _authController = AuthController();

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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  var user = await _authController.login(emailController.text, passwordController.text);
                  if (user != null) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => HomeView(user: user)));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur de connexion')));
                  }
                },
                child: Text('Se connecter'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterView()));
                },
                child: Text('Créer un compte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
