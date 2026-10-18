import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'historypage.dart';
import 'configpage.dart';
import '../services/relatorio_service.dart';
import '../services/ciclo_notification_manager.dart';
import '../models/ciclo_incubacao.dart';

class HomePage extends StatelessWidget {
  final RelatorioService? relatorioService;
  final CicloNotificationManager cicloNotificationManager;

  const HomePage({
    super.key,
    this.relatorioService,
    required this.cicloNotificationManager,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        top: 60, left: 20, right: 20, bottom: 20),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2D8133),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Eclochick",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications,
                              color: Colors.white),
                          onPressed: () => _verificarNotificacoes(context),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Dispositivo conectado  ",
                              style: TextStyle(fontSize: 12)),
                          Icon(Icons.wifi, size: 16, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
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
                        children: const [
                          Text(
                            "Período de incubação",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "16",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "dias de incubação",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: LinearProgressIndicator(
                              value: 0.75,
                              minHeight: 12,
                              backgroundColor: Colors.white,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFC6FF00)),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Faltam 5 dias para o nascimento",
                            style:
                                TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        _buildSensorCard("Temperatura", "37,0 C°",
                            Icons.thermostat, Colors.red),
                        const SizedBox(width: 20),
                        _buildSensorCard("Umidade", "64,8%",
                            Icons.water_drop, Colors.blue),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context,
                  Icons.timeline,
                  "Dados de incubação",
                  HistoryPage(
                    relatorioService: relatorioService ??
                        RelatorioService(FirebaseDatabase.instance),
                  ),
                ),
                _buildNavItem(
                    context, Icons.settings, "Config", const ConfigPage()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _verificarNotificacoes(BuildContext context) async {
    final db = FirebaseDatabase.instance;
    final snapshot = await db.ref('ciclos').get();

    if (!snapshot.exists) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nenhum ciclo encontrado.')),
        );
      }
      return;
    }

    final data = snapshot.value as Map<dynamic, dynamic>;
    final ciclos = data.entries.map((e) {
      final map = Map<String, dynamic>.from(e.value as Map);
      return CicloIncubacao(
        id: e.key.toString(),
        duracaoDias: (map['duracaoDias'] as num?)?.toInt() ?? 21,
      )..dataInicio = map['dataInicio'] != null
          ? DateTime.parse(map['dataInicio'] as String)
          : null;
    }).toList();

    await cicloNotificationManager.verificarCiclos(ciclos);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verificação concluída.')),
      );
    }
  }

  Widget _buildSensorCard(
      String title, String value, IconData icon, Color iconColor) {
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
            Text(value,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label,
      Widget destinationPage) {
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
          Text(label,
              style: const TextStyle(fontSize: 10, color: Colors.black54)),
        ],
      ),
    );
  }
}