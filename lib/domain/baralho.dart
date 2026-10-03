import 'carta.dart';

class Baralho {
  const Baralho({required this.nome, required this.cartas, this.preco = 0});

  final String nome;
  final List<Carta> cartas;
  final int preco;

  bool get gratuito => preco == 0;
}
