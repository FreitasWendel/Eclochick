import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de exemplo
    final List<Map<String, String>> historico = [
      {"data": "10/01/2026", "resultado": "18 pintinhos", "taxa": "90%"},
      {"data": "15/02/2026", "resultado": "15 pintinhos", "taxa": "75%"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Histórico de Incubação", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2D8133),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: historico.length,
        itemBuilder: (context, index) { 
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.egg, color: Colors.orange),
              title: Text("Início: ${historico[index]['data']}"),
              subtitle: Text("Sucesso: ${historico[index]['resultado']}"),
              trailing: Text(
                historico[index]['taxa']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: Color(0xFF2D8133)
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}