import 'package:flutter/foundation.dart';

import 'baralho.dart';

class Loja extends ChangeNotifier {
  int _moedas = 0;
  final Set<Baralho> _comprados = {};

  int get moedas => _moedas;

  bool liberado(Baralho baralho) =>
      baralho.gratuito || _comprados.contains(baralho);

  void ganhar(int valor) {
    _moedas += valor;
    notifyListeners();
  }

  void comprar(Baralho baralho) {
    if (_moedas < baralho.preco) throw StateError('Moedas insuficientes');
    _moedas -= baralho.preco;
    _comprados.add(baralho);
    notifyListeners();
  }
}
