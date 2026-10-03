import 'baralho.dart';

class Configuracao {
  const Configuracao({
    required this.nomeTimeA,
    required this.nomeTimeB,
    required this.baralho,
    this.segundosPorTurno = 60,
    this.rodadas = 3,
    this.pulosPorTurno = 2,
  });

  final String nomeTimeA;
  final String nomeTimeB;
  final Baralho baralho;
  final int segundosPorTurno;
  final int rodadas;
  final int pulosPorTurno;
}
