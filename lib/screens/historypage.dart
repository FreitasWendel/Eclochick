import 'package:flutter/material.dart';
import '../models/historico_incubacao.dart';
import '../services/relatorio_service.dart';

class HistoryPage extends StatefulWidget {
  final RelatorioService relatorioService;

  const HistoryPage({super.key, required this.relatorioService});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<HistoricoIncubacao>> _historicoFuture;

  @override
  void initState() {
    super.initState();
    _historicoFuture = widget.relatorioService.buscarHistorico();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Histórico de Incubação", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2D8133),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<HistoricoIncubacao>>(
        future: _historicoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Erro ao carregar histórico."));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum histórico encontrado."));
          }

          final historico = snapshot.data!;
          return ListView.builder(
            itemCount: historico.length,
            itemBuilder: (context, index) {
              final item = historico[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.egg, color: Colors.orange),
                  title: Text("Início: ${item.data}"),
                  subtitle: Text("Sucesso: ${item.resultado}"),
                  trailing: Text(
                    item.taxa,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF2D8133)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}