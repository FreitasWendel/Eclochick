import 'package:flutter_test/flutter_test.dart';

import 'package:eclochick/models/parametros_incubacao.dart';

void main() {

  group('CT01-CT02 - valores padrão', () {
    test('CT01: gerenciador inicia com os parâmetros padrão', () {
      final g = GerenciadorParametros();
      expect(g.atual.temperatura, 37.5);
      expect(g.atual.umidade, 60.0);
      expect(g.atual.dias, 21);
    });                                                                                                                                                               

    test('CT02: restaurarPadrao desfaz alterações', () {
      final g = GerenciadorParametros();
      g.atualizar(temperatura: 38.0, umidade: 70.0, dias: 25);
      g.restaurarPadrao();
      expect(g.atual.temperatura, 37.5);
      expect(g.atual.umidade, 60.0);
      expect(g.atual.dias, 21);
    });                                                                                                                                                                                                                 
  });                                                                                                                                                                             


  const temperaturas = <(String, double, bool)>[
    ('abaixo do mínimo', 34.9, false),
    ('limite mínimo', 35.0, true),
    ('logo acima do mínimo', 35.1, true),
    ('valor típico', 37.5, true),
    ('logo abaixo do máximo', 39.9, true),
    ('limite máximo', 40.0, true),
    ('acima do máximo', 40.1, false),
    ('negativo', -5.0, false),
    ('NaN', double.nan, false),
  ];

  group('CT03 - validação de TEMPERATURA (valor limite)', () {
    for (final (desc, valor, valido) in temperaturas) {
      test('$desc ($valor) -> ${valido ? "aceita" : "rejeita"}', () {
        final erro = ParametrosIncubacao.validarTemperatura(valor);
        expect(erro == null, valido);
      });                                                                                                                                                                                         
    }
  });                                                                                                                                     

  const umidades = <(String, double, bool)>[
    ('abaixo do mínimo', 29.9, false),
    ('limite mínimo', 30.0, true),
    ('valor típico', 60.0, true),
    ('limite máximo', 90.0, true),
    ('acima do máximo', 90.1, false),
    ('negativo', -1.0, false),
    ('NaN', double.nan, false),
  ];

  group('CT04 - validação de UMIDADE (valor limite)', () {
    for (final (desc, valor, valido) in umidades) {
      test('$desc ($valor) -> ${valido ? "aceita" : "rejeita"}', () {
        final erro = ParametrosIncubacao.validarUmidade(valor);
        expect(erro == null, valido);
      });                                                                                                                                               
    }
  });                                                                                                                                         

  const dias = <(String, int, bool)>[
    ('zero', 0, false),
    ('limite mínimo', 1, true),
    ('valor típico (galinha)', 21, true),
    ('limite máximo', 30, true),
    ('acima do máximo', 31, false),
    ('negativo', -3, false),
  ];

  group('CT05 - validação de DIAS DE INCUBAÇÃO (valor limite)', () {
    for (final (desc, valor, valido) in dias) {
      test('$desc ($valor) -> ${valido ? "aceita" : "rejeita"}', () {
        final erro = ParametrosIncubacao.validarDias(valor);
        expect(erro == null, valido);
      });
    }
  });                                                                                                                                         

  const combinacoes = <(String, double, double, int, int)>[
    ('todos válidos', 38.0, 55.0, 21, 0),
    ('só temperatura inválida', 50.0, 55.0, 21, 1),
    ('só umidade inválida', 38.0, 95.0, 21, 1),
    ('só dias inválido', 38.0, 55.0, 0, 1),
    ('temperatura e umidade inválidas', 10.0, 5.0, 21, 2),
    ('todos inválidos', 10.0, 5.0, 99, 3),
  ];

  group('CT06 - atualização combinada (parametrizado)', () {
    for (final (desc, t, u, d, qtdErros) in combinacoes) {
      test('$desc -> $qtdErros erro(s)', () {
        final g = GerenciadorParametros();
        final erros = g.atualizar(temperatura: t, umidade: u, dias: d);

        expect(erros.length, qtdErros);

        if (qtdErros == 0) {
          
          expect(g.atual.temperatura, t);
          expect(g.atual.umidade, u);
          expect(g.atual.dias, d);
        } else {
          
          expect(g.atual.temperatura, 37.5);
          expect(g.atual.umidade, 60.0);
          expect(g.atual.dias, 21);
        }
      });                                                                                                                                                                             
    }
  });                                                                                                                                                                   


  group('CT07 - persistência da configuração', () {
    test('atualização inválida NÃO sobrescreve configuração válida anterior',
        () {
      final g = GerenciadorParametros();
      g.atualizar(temperatura: 38.0, umidade: 55.0, dias: 21);
      g.atualizar(temperatura: 99.0, umidade: 55.0, dias: 21); 

      expect(g.atual.temperatura, 38.0);
    });                                                                                                                                                                                               
  });                                                                                                                         

  
  const restantes = <(int, int, int)>[
    (21, 0, 21),
    (21, 16, 5), 
    (21, 21, 0),
    (21, 25, 0), 
  ];

  group('CT08 - dias restantes (parametrizado)', () {
    for (final (total, decorridos, esperado) in restantes) {
      test('$decorridos de $total dias -> faltam $esperado', () {
        final p = ParametrosIncubacao(
          temperatura: 37.5,
          umidade: 60,
          dias: total,
        );
        expect(p.diasRestantes(decorridos), esperado);
      });                                                                                                               
    }
  });                                                                                                                           
}
