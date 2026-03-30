import 'package:flutter/material.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurações", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2D8133),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Text(
          "Configurações do Eclochick",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}