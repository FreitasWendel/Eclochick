
class ParametrosIncubacao {
  static const double tempMin = 35.0;
  static const double tempMax = 40.0;
  static const double umidadeMin = 30.0;
  static const double umidadeMax = 90.0;
  static const int diasMin = 1;
  static const int diasMax = 30;

  final double temperatura; 
  final double umidade;
  final int dias; 

  const ParametrosIncubacao({
    required this.temperatura,
    required this.umidade,
    required this.dias,
  });

  const ParametrosIncubacao.padrao()
      : temperatura = 37.5,
        umidade = 60.0,
        dias = 21;

  static String? validarTemperatura(double v) =>
      (v >= tempMin && v <= tempMax)
          ? null
          : 'Temperatura deve estar entre $tempMin e $tempMax °C';

  static String? validarUmidade(double v) =>
      (v >= umidadeMin && v <= umidadeMax)
          ? null
          : 'Umidade deve estar entre $umidadeMin e $umidadeMax %';

  static String? validarDias(int v) => (v >= diasMin && v <= diasMax)
      ? null
      : 'Dias deve estar entre $diasMin e $diasMax';

  int diasRestantes(int diasDecorridos) {
    final r = dias - diasDecorridos;
    return r < 0 ? 0 : r;
  }
}


class GerenciadorParametros {
  ParametrosIncubacao _atual = const ParametrosIncubacao.padrao();

  ParametrosIncubacao get atual => _atual;

  List<String> atualizar({
    required double temperatura,
    required double umidade,
    required int dias,
  }) {
    final erros = <String>[
      ?ParametrosIncubacao.validarTemperatura(temperatura),
      ?ParametrosIncubacao.validarUmidade(umidade),
      ?ParametrosIncubacao.validarDias(dias),
    ];
    if (erros.isEmpty) {
      _atual = ParametrosIncubacao(
        temperatura: temperatura,
        umidade: umidade,
        dias: dias,
      );
    }
    return erros;
  }

  void restaurarPadrao() => _atual = const ParametrosIncubacao.padrao();
}
