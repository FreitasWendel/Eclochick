import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:eclochick/models/historico_incubacao.dart';
import 'package:eclochick/services/relatorio_service.dart';

class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}
class MockDatabaseReference extends Mock implements DatabaseReference {}
class MockDataSnapshot extends Mock implements DataSnapshot {}

void main() {
  late MockFirebaseDatabase mockDatabase;
  late MockDatabaseReference mockReference;
  late MockDataSnapshot mockSnapshot;
  late RelatorioService relatorioService;

  final mockJsonData = {
    'id1': {'data': '10/01/2026', 'resultado': '18 pintinhos', 'taxa': '90%'},
    'id2': {'data': '15/02/2026', 'resultado': '15 pintinhos', 'taxa': '75%'},
  };

  setUp(() {
    mockDatabase = MockFirebaseDatabase();
    mockReference = MockDatabaseReference();
    mockSnapshot = MockDataSnapshot();
    relatorioService = RelatorioService(mockDatabase);

    when(() => mockDatabase.ref(any())).thenReturn(mockReference);
  });

  group('RelatorioService - Testes Unitários', () {
    test('deve retornar uma lista de HistoricoIncubacao quando o banco tiver dados', () async {
      when(() => mockReference.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.exists).thenReturn(true);
      when(() => mockSnapshot.value).thenReturn(mockJsonData);

      final resultado = await relatorioService.buscarHistorico();

      expect(resultado.length, 2);
      expect(resultado[0].data, '10/01/2026');
      expect(resultado[0].taxa, '90%');
      expect(resultado[1].resultado, '15 pintinhos');
    });

    test('deve retornar lista vazia quando o banco não tiver dados', () async {
      when(() => mockReference.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.exists).thenReturn(false);

      final resultado = await relatorioService.buscarHistorico();

      expect(resultado.isEmpty, true);
    });
  });

  group('HistoricoIncubacao - Testes de Modelo', () {
    test('deve converter JSON para o Modelo corretamente', () {
      final json = {'data': '20/03/2026', 'resultado': '20 pintinhos', 'taxa': '100%'};
      
      final modelo = HistoricoIncubacao.fromJson(json);
      
      expect(modelo.data, '20/03/2026');
      expect(modelo.resultado, '20 pintinhos');
      expect(modelo.taxa, '100%');
    });
  });
}