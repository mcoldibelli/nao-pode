enum Resultado {
  acertou(1),
  errou(-1),
  pulou(0);

  const Resultado(this.pontos);
  final int pontos;
}
