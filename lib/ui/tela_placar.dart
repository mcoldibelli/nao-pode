import 'package:flutter/material.dart';

import '../domain/loja.dart';
import '../domain/partida.dart';
import 'tela_turno.dart';

class TelaPlacar extends StatelessWidget {
  const TelaPlacar({super.key, required this.partida, required this.loja});

  final Partida partida;
  final Loja loja;

  void _comecarTurno(BuildContext context) {
    partida.iniciarTurno();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TelaTurno(partida: partida, loja: loja),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vencedor = partida.vencedor;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          partida.acabou
              ? 'Fim de jogo'
              : 'Rodada ${partida.rodada} de ${partida.config.rodadas}',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final time in partida.times)
                ListTile(
                  title: Text(time.nome),
                  trailing: Text('${time.pontos} pts'),
                ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    if (partida.acabou) ...[
                      Text(
                        vencedor == null
                            ? 'Empate!'
                            : '${vencedor.nome} venceu!',
                      ),
                      Text('Moedas ganhas: ${partida.moedasGanhas}'),
                    ] else
                      Text('Vez de: ${partida.timeDaVez.nome}'),
                  ],
                ),
              ),
              if (partida.acabou)
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Voltar ao início'),
                )
              else
                ElevatedButton(
                  onPressed: () => _comecarTurno(context),
                  child: const Text('Começar turno'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
