import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'estilo.dart';
import 'psiu.dart';

const _regras = [
  (
    Icons.groups_rounded,
    sol,
    tinta,
    'Times',
    'Dois times jogam em turnos. Quem explica segura o celular.',
  ),
  (
    Icons.block_rounded,
    rosaClaro,
    framboesaBase,
    'Proibidas',
    'Explique a palavra da carta sem falar as cinco proibidas.',
  ),
  (
    Icons.swipe_right_rounded,
    turquesa,
    turquesaTexto,
    'Acertou',
    'O time adivinhou: arraste a carta para a direita. +1 ponto.',
  ),
  (
    Icons.swipe_left_rounded,
    rosaClaro,
    framboesaBase,
    'Errou',
    'Falou uma proibida: arraste para a esquerda. -1 ponto.',
  ),
  (
    Icons.swipe_vertical_rounded,
    sol,
    tinta,
    'Pulou',
    'Arraste para cima ou para baixo para trocar a carta, sem pontos. '
        'Os pulos por turno são limitados.',
  ),
  (
    Icons.emoji_events_rounded,
    turquesa,
    turquesaTexto,
    'Fim',
    'Depois das rodadas, o time com mais pontos vence.',
  ),
];

class TelaTutorial extends StatelessWidget {
  const TelaTutorial({super.key});

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Como jogar')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Row(
            spacing: 8,
            children: [
              const Psiu(tamanho: 92),
              const Flexible(
                child: Fala('É simples: bico fechado nas proibidas!'),
              ),
            ],
          ).animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 16),
          for (final (i, (icone, fundo, frente, titulo, texto))
              in _regras.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child:
                  Container(
                        padding: const EdgeInsets.all(14),
                        decoration: cartaoPop(context),
                        child: Row(
                          spacing: 14,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: fundo,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(icone, color: frente, size: 28),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 2,
                                children: [
                                  Text(
                                    titulo,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge,
                                  ),
                                  Text(
                                    texto,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      height: 1.3,
                                      color: cores.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate(delay: (60 * i).ms)
                      .fadeIn(duration: 250.ms)
                      .slideY(begin: 0.15, curve: Curves.easeOutBack),
            ),
        ],
      ),
    );
  }
}
