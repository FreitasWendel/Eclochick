import 'package:flutter/material.dart';
import 'screens/homepage.dart'; // Importa a tela que vamos criar

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Tira aquela faixa vermelha de "debug"
      title: 'Eclochick',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomePage(), // Diz que a primeira tela é a HomePage
    );
  }
}