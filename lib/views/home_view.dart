import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'admin_view.dart';

class HomeView extends StatelessWidget {
  final AppUser user;

  const HomeView({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Accueil')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bienvenue, ${user.email}'),
            Text('Rôle: ${user.role}'),
            SizedBox(height: 20),
            if (user.role == 'admin')
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => AdminView()));
                },
                child: Text('Page Admin'),
              ),
          ],
        ),
      ),
    );
  }
}
