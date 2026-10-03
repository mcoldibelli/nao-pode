import 'package:projeto/domain/resultado.dart';

import 'carta.dart';

class Jogada {
  const Jogada(this.carta, this.resultado);

  final Carta carta;
  final Resultado resultado;
}
