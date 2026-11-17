import 'package:flutter/foundation.dart';
import 'package:projeto/domain/resultado.dart';
import 'package:projeto/domain/time.dart';

import 'carta.dart';
import 'configuracao.dart';
import 'jogada.dart';

class Partida extends ChangeNotifier {
  Partida(this.config)
    : times = [Time(config.nomeTimeA), Time(config.nomeTimeB)],
      _monte = [...config.baralho.cartas]..shuffle();

  final Configuracao config;
  final List<Time> times;
  final List<Carta> _monte;
  final List<Jogada> _jogadasDoTurno = [];
  int _turno = 0;
  int _proximaCarta = 0;
  int _pulosRestantes = 0;

  Time get timeDaVez => times[_turno % 2];
  int get rodada => _turno ~/ 2 + 1;
  bool get acabou => _turno >= config.rodadas * 2;
  int get pulosRestantes => _pulosRestantes;
  List<Jogada> get jogadasDoTurno => List.unmodifiable(_jogadasDoTurno);

  Carta get cartaAtual => _monte[_proximaCarta % _monte.length];

  Time? get vencedor {
    final [a, b] = times;
    if (a.pontos == b.pontos) return null;
    return a.pontos > b.pontos ? a : b;
  }

  void iniciarTurno() {
    _jogadasDoTurno.clear();
    _pulosRestantes = config.pulosPorTurno;
    notifyListeners();
  }

  void registrar(Resultado resultado) {
    if (resultado == Resultado.pulou) {
      if (_pulosRestantes == 0) throw StateError('Sem pulos neste turno');
      _pulosRestantes--;
    }
    timeDaVez.somar(resultado.pontos);
    _jogadasDoTurno.add(Jogada(cartaAtual, resultado));
    _proximaCarta++;
    notifyListeners();
  }

  void encerrarTurno() {
    _turno++;
    notifyListeners();
  }
}
