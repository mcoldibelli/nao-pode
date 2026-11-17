import 'package:flutter/material.dart';

import '../domain/partida.dart';
import 'tela_turno.dart';

class TelaPlacar extends StatelessWidget {
  const TelaPlacar({super.key, required this.partida});

  final Partida partida;

  void _comecarTurno(BuildContext context) {
    partida.iniciarTurno();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => TelaTurno(partida: partida)),
    );
  }

  Future<void> _confirmarSaida(BuildContext context) async {
    final sair = await showDialog<bool>(
      context: context,
      builder: (dialogo) => AlertDialog(
        title: const Text('Sair da partida?'),
        content: const Text('O placar desta partida será perdido.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogo, false),
            child: const Text('Continuar jogando'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogo, true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
    if (sair == true && context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final vencedor = partida.vencedor;
    return PopScope(
      canPop: partida.acabou,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmarSaida(context);
      },
      child: Scaffold(
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
                      if (partida.acabou)
                        Text(
                          vencedor == null
                              ? 'Empate!'
                              : '${vencedor.nome} venceu!',
                        )
                      else
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
      ),
    );
  }
}
