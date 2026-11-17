import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../domain/partida.dart';
import 'estilo.dart';
import 'psiu.dart';
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
                Row(
                  spacing: 12,
                  children: [
                    for (final time in partida.times)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: cartaoPop(
                            context,
                            borda: !partida.acabou && time == partida.timeDaVez
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                          child: Column(
                            children: [
                              Text(
                                time.nome,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                '${time.pontos}',
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              const Text(
                                'pontos',
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8,
                    children: [
                      if (partida.acabou) ...[
                        Psiu(feliz: vencedor != null, tamanho: 150)
                            .animate()
                            .scale(duration: 500.ms, curve: Curves.elasticOut),
                        Text(
                          vencedor == null
                              ? 'Empate!'
                              : '${vencedor.nome} venceu!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ] else ...[
                        const Psiu(tamanho: 110),
                        Text(
                          'Vez de: ${partida.timeDaVez.nome}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
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
