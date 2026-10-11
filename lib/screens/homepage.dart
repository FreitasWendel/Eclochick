import 'package:flutter/material.dart';
import 'historypage.dart';
import 'configpage.dart';

void main() {
  runApp(const EclochickApp());
}

class EclochickApp extends StatelessWidget {
  const EclochickApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Fundo levemente cinza
      body: Column(
        children: [
          // --- HEADER VERDE ---
          Container(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
            decoration: const BoxDecoration(
              color: Color(0xFF2D8133), // Verde do Eclochick
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Eclochick",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.notifications, color: Colors.white),
              ],
            ),
          ),

          // --- STATUS DE CONEXÃO ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Dispositivo conectado  ", style: TextStyle(fontSize: 12)),
                  Icon(Icons.wifi, size: 16, color: Colors.black),
                ],
              ),
            ),
          ),

          // --- CARD PERÍODO DE INCUBAÇÃO ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: const Color(0xFF5AB45F),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    "Período de incubação",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "16",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "dias de incubação",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  // BARRA DE PROGRESSO
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const LinearProgressIndicator(
                      value: 0.75, // 16 de 21 dias por exemplo
                      minHeight: 12,
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC6FF00)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Faltam 5 dias para o nascimento",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // --- GRID DE TEMPERATURA E UMIDADE ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildSensorCard("Temperatura", "37,0 C°", Icons.thermostat, Colors.red),
                const SizedBox(width: 20),
                _buildSensorCard("Umidade", "64,8%", Icons.water_drop, Colors.blue),
              ],
            ),
          ),

          const Spacer(),

          // --- NAVEGAÇÃO INFERIOR CUSTOMIZADA ---
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
  _buildNavItem(context, Icons.timeline, "Dados de incubação", const HistoryPage()), 
  _buildNavItem(context, Icons.settings, "Config", const ConfigPage()),     

],
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para os cartões de sensores
  Widget _buildSensorCard(String title, String value, IconData icon, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Icon(icon, color: iconColor, size: 30),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para os itens do menu inferior
  Widget _buildNavItem(BuildContext context, IconData icon, String label, Widget destinationPage) { 
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationPage),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.black54),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.black54)),
        ],
      ),
    );
  }
  
}



