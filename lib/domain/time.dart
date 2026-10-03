class Time {
  Time(this.nome);

  final String nome;
  int _pontos = 0;

  int get pontos => _pontos;

  void somar(int valor) {
    _pontos += valor;
  }
}
