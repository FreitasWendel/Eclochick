import 'package:firebase_database/firebase_database.dart';
import '../models/historico_incubacao.dart';

class RelatorioService {
  final FirebaseDatabase _database;

  
  RelatorioService(this._database);

  Future<List<HistoricoIncubacao>> buscarHistorico() async {
    try {
      
      final snapshot = await _database.ref('historico').get();
      
      if (snapshot.exists && snapshot.value != null) {
        final Map<dynamic, dynamic> dados = snapshot.value as Map<dynamic, dynamic>;
        
        
        return dados.values.map((item) => HistoricoIncubacao.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      
      throw Exception('Erro ao buscar histórico: $e');
    }
  }
}