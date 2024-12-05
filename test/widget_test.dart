// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test/flutter_test.dart';


import 'package:task_list/main.dart';

void main() {
  testWidgets('Testa se o título aparece na tela', (WidgetTester tester) async {
    // Inicializa o aplicativo TodoApp
    await tester.pumpWidget(TodoApp());

    // Verifica se o título "Minhas Tarefas" aparece na tela
    expect(find.text('Minhas Tarefas'), findsOneWidget);
  });
}
