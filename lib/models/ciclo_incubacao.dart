enum EstadoCiclo { naoIniciado, emAndamento, pausado, finalizado, cancelado }

class CicloIncubacao {
  final String id;
  DateTime? dataInicio;
  int duracaoDias;
  EstadoCiclo estado;

  CicloIncubacao({
    required this.id,
    this.dataInicio,
    this.duracaoDias = 21,
    this.estado = EstadoCiclo.naoIniciado,
  });

  bool iniciar() {
    if (estado != EstadoCiclo.naoIniciado) return false;
    dataInicio = DateTime.now();
    estado = EstadoCiclo.emAndamento;
    return true;
  }

  bool alterarDuracao(int novaDuracao) {
    if (novaDuracao < 1 || novaDuracao > 30) return false;
    if (estado == EstadoCiclo.finalizado || estado == EstadoCiclo.cancelado) {
      return false;
    }
    duracaoDias = novaDuracao;
    return true;
  }

  int diasDecorridos([DateTime? dataReferencia]) {
    if (dataInicio == null || estado == EstadoCiclo.naoIniciado) return 0;
    final agora = dataReferencia ?? DateTime.now();
    final diferenca = agora.difference(dataInicio!).inDays;
    return diferenca < 0 ? 0 : diferenca;
  }

  int diasRestantes([DateTime? dataReferencia]) {
    if (estado == EstadoCiclo.naoIniciado) return duracaoDias;
    final restantes = duracaoDias - diasDecorridos(dataReferencia);
    return restantes < 0 ? 0 : restantes;
  }

  bool finalizar() {
    if (estado != EstadoCiclo.emAndamento && estado != EstadoCiclo.pausado) {
      return false;
    }
    estado = EstadoCiclo.finalizado;
    return true;
  }

  bool cancelar() {
    if (estado == EstadoCiclo.finalizado) return false;
    estado = EstadoCiclo.cancelado;
    return true;
  }
}