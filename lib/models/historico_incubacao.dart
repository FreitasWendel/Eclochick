class HistoricoIncubacao {
  final String data;
  final String resultado;
  final String taxa;

  HistoricoIncubacao({
    required this.data,
    required this.resultado,
    required this.taxa,
  });

  
  factory HistoricoIncubacao.fromJson(Map<dynamic, dynamic> json) {
    return HistoricoIncubacao(
      data: json['data'] ?? '',
      resultado: json['resultado'] ?? '',
      taxa: json['taxa'] ?? '',
    );
  }
}