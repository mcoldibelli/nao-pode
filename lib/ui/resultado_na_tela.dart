import '../domain/resultado.dart';

extension ResultadoNaTela on Resultado {
  String get rotulo => switch (this) {
    Resultado.acertou => 'Acertou',
    Resultado.errou => 'Errou',
    Resultado.pulou => 'Pulou',
  };

  String get som => switch (this) {
    Resultado.acertou => 'acertou',
    Resultado.errou => 'errou',
    Resultado.pulou => 'pulou',
  };
}
