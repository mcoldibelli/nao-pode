import 'package:flutter/material.dart';

import '../domain/loja.dart';
import '../domain/partida.dart';

class TelaPlacar extends StatelessWidget {
  const TelaPlacar({super.key, required this.partida, required this.loja});

  final Partida partida;
  final Loja loja;

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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final time in partida.times)
            ListTile(
              title: Text(time.nome),
              trailing: Text('${time.pontos} pts'),
            ),
          const SizedBox(height: 16),
          if (partida.acabou)
            Text(vencedor == null ? 'Empate!' : '${vencedor.nome} venceu!')
          else
            Text('Vez de: ${partida.timeDaVez.nome}'),
        ],
      ),
    );
  }
}
