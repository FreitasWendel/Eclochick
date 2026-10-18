import 'package:flutter_test/flutter_test.dart';
import 'package:eclochick/models/ciclo_incubacao.dart';

void main() {
  group('CT01_CICLO - Inicialização e Estado Inicial', () {
    test('Ciclo recém-criado deve iniciar no estado naoIniciado', () {
      final ciclo = CicloIncubacao(id: 'c1');
      expect(ciclo.estado, EstadoCiclo.naoIniciado);
      expect(ciclo.diasDecorridos(), 0);
      expect(ciclo.diasRestantes(), 21);
    });

    test('Deve iniciar o ciclo com sucesso gravando a data de início', () {
      final ciclo = CicloIncubacao(id: 'c1');
      final sucesso = ciclo.iniciar();

      expect(sucesso, isTrue);
      expect(ciclo.estado, EstadoCiclo.emAndamento);
      expect(ciclo.dataInicio, isNotNull);
    });
  });

  group('CT02_CICLO - Modificação de Parâmetros Variáveis (Duração)', () {
    test('Deve permitir alterar a duração enquanto o ciclo estiver ativo', () {
      final ciclo = CicloIncubacao(id: 'c1');
      ciclo.iniciar();

      final alterado = ciclo.alterarDuracao(25);

      expect(alterado, isTrue);
      expect(ciclo.duracaoDias, 25);
    });

    test('NÃO deve permitir alterar a duração se o ciclo estiver finalizado', () {
      final ciclo = CicloIncubacao(id: 'c1');
      ciclo.iniciar();
      ciclo.finalizar();

      final alterado = ciclo.alterarDuracao(28);

      expect(alterado, isFalse);
      expect(ciclo.duracaoDias, 21);
    });

    test('NÃO deve aceitar durações inválidas (0, negativas ou > 30)', () {
      final ciclo = CicloIncubacao(id: 'c1');

      expect(ciclo.alterarDuracao(0), isFalse);
      expect(ciclo.alterarDuracao(-5), isFalse);
      expect(ciclo.alterarDuracao(31), isFalse);
      expect(ciclo.duracaoDias, 21);
    });
  });

  const tabelaTempo = <(int, int, int)>[
    (0, 0, 21),
    (10, 10, 11),
    (21, 21, 0),
    (25, 25, 0),
  ];

  group('CT03_CICLO - Cálculo Temporal e Dias Restantes (Parametrizado)', () {
    for (final (diasPassados, decorridosEsp, restantesEsp) in tabelaTempo) {
      test('Simulando $diasPassados dias passados -> Decorridos: $decorridosEsp, Restantes: $restantesEsp', () {
        final inicio = DateTime.now().subtract(Duration(days: diasPassados));
        final ciclo = CicloIncubacao(
          id: 'c1',
          dataInicio: inicio,
          estado: EstadoCiclo.emAndamento,
        );

        expect(ciclo.diasDecorridos(), decorridosEsp);
        expect(ciclo.diasRestantes(), restantesEsp);
      });
    }
  });

  group('CT04_CICLO - Transição e Encerramento de Estados', () {
    test('Deve finalizar o ciclo e proibir reinício', () {
      final ciclo = CicloIncubacao(id: 'c1');
      ciclo.iniciar();

      final finalizou = ciclo.finalizar();

      expect(finalizou, isTrue);
      expect(ciclo.estado, EstadoCiclo.finalizado);
      expect(ciclo.iniciar(), isFalse);
    });

    test('NÃO deve cancelar um ciclo já finalizado', () {
      final ciclo = CicloIncubacao(id: 'c1');
      ciclo.iniciar();
      ciclo.finalizar();

      final cancelou = ciclo.cancelar();

      expect(cancelou, isFalse);
      expect(ciclo.estado, EstadoCiclo.finalizado);
    });
  });
}