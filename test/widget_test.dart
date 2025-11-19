import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bibliothequescolaire/main.dart';

void main() {
  testWidgets('App démarre et affiche l\'écran HomeScreen', (WidgetTester tester) async {
    // Construire l'application normalement
    await tester.pumpWidget(MyApp());

    // Vérifier l'écran de base
    expect(find.text('Connexion Réussie!'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);

    // Cliquer sur le bouton pour aller à la liste des documents
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Vérifier que l'écran DocumentListVue s'affiche
    expect(find.text('Catalogue de documents'), findsOneWidget);
  });
}
