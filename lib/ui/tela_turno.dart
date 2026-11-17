import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../domain/partida.dart';
import '../domain/resultado.dart';
import 'estilo.dart';
import 'psiu.dart';
import 'resultado_na_tela.dart';
import 'sons.dart';
import 'tela_resumo_cartas.dart';

class TelaTurno extends StatefulWidget {
  const TelaTurno({super.key, required this.partida});

  final Partida partida;

  @override
  State<TelaTurno> createState() => _TelaTurnoState();
}

class _TelaTurnoState extends State<TelaTurno> {
  late int _segundosRestantes = widget.partida.config.segundosPorTurno;
  late final Timer _relogio;
  Timer? _fimDoAviso;
  Resultado? _aviso;

  @override
  void initState() {
    super.initState();
    _relogio = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _passarSegundo(),
    );
  }

  @override
  void dispose() {
    _relogio.cancel();
    _fimDoAviso?.cancel();
    super.dispose();
  }

  void _passarSegundo() {
    if (_segundosRestantes > 1) {
      setState(() => _segundosRestantes--);
      if (_segundosRestantes <= 10) tocarSom('tique');
      return;
    }
    _relogio.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TelaResumoCartas(partida: widget.partida),
      ),
    );
  }

  void _registrar(Resultado resultado) {
    widget.partida.registrar(resultado);
    tocarSom(resultado.som);
    if (resultado == Resultado.acertou) HapticFeedback.lightImpact();
    if (resultado == Resultado.errou) HapticFeedback.heavyImpact();
    _fimDoAviso?.cancel();
    setState(() => _aviso = resultado);
    _fimDoAviso = Timer(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _aviso = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final partida = widget.partida;
    final cores = Theme.of(context).colorScheme;
    final total = partida.config.segundosPorTurno;
    final urgente = _segundosRestantes <= 10;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: ListenableBuilder(
            listenable: partida,
            builder: (context, _) {
              final carta = partida.cartaAtual;
              final jogadas = partida.jogadasDoTurno.length;
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 14,
                      children: [
                        Row(
                          spacing: 12,
                          children: [
                            Expanded(
                              child: _BarraDeTempo(
                                fracao: _segundosRestantes / total,
                                cor: urgente ? framboesa : sol,
                              ),
                            ),
                            Text(
                              '${_segundosRestantes}s',
                              semanticsLabel:
                                  '$_segundosRestantes segundos restantes',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: urgente
                                        ? cores.primary
                                        : const Color(0xFFB87400),
                                  ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  text: 'Vez do ',
                                  children: [
                                    TextSpan(
                                      text: partida.timeDaVez.nome,
                                      style: TextStyle(color: cores.primary),
                                    ),
                                  ],
                                ),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            Chip(
                              label: Text(
                                '${partida.timeDaVez.pontos} pts',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child:
                              _Carta(
                                    baralho: partida.config.baralho.nome,
                                    palavra: carta.palavra,
                                    proibidas: carta.proibidas,
                                  )
                                  .animate(key: ValueKey(jogadas))
                                  .fadeIn(duration: 180.ms)
                                  .slideY(
                                    begin: 0.08,
                                    curve: Curves.easeOutBack,
                                    duration: 320.ms,
                                  ),
                        ),
                        Row(
                          spacing: 12,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: estiloPop(
                                  cor: rosaClaro,
                                  base: const Color(0xFFF2A9BC),
                                  texto: framboesaBase,
                                ),
                                onPressed: () => _registrar(Resultado.errou),
                                child: const Text('Errou'),
                              ),
                            ),
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: cores.onSurface,
                                ),
                                onPressed: partida.pulosRestantes > 0
                                    ? () => _registrar(Resultado.pulou)
                                    : null,
                                child: Text(
                                  'Pular (${partida.pulosRestantes})',
                                ),
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: estiloPop(
                            cor: turquesa,
                            base: turquesaBase,
                            texto: turquesaTexto,
                          ),
                          onPressed: () => _registrar(Resultado.acertou),
                          child: const Text('Acertou'),
                        ),
                      ],
                    ),
                  ),
                  if (_aviso == Resultado.acertou)
                    const Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: IgnorePointer(child: _AvisoDeAcerto()),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BarraDeTempo extends StatelessWidget {
  const _BarraDeTempo({required this.fracao, required this.cor});

  final double fracao;
  final Color cor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AnimatedFractionallySizedBox(
          duration: const Duration(milliseconds: 900),
          widthFactor: fracao,
          heightFactor: 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: cor,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
      ),
    );
  }
}

class _Carta extends StatelessWidget {
  const _Carta({
    required this.baralho,
    required this.palavra,
    required this.proibidas,
  });

  final String baralho;
  final String palavra;
  final List<String> proibidas;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: cartaoPop(context, base: 6),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: turquesaClaro,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  baralho.toUpperCase(),
                  style: const TextStyle(
                    color: turquesaEscuro,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            Text(
              palavra,
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(fontSize: 34, height: 1.05),
            ),
            Row(
              spacing: 6,
              children: [
                Icon(Icons.block_rounded, size: 18, color: cores.primary),
                Text(
                  'NÃO PODE FALAR',
                  style: TextStyle(
                    color: cores.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            for (final proibida in proibidas)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                decoration: cartaoPop(context),
                child: Text(
                  proibida,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AvisoDeAcerto extends StatelessWidget {
  const _AvisoDeAcerto();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: turquesaClaro,
      padding: const EdgeInsets.fromLTRB(24, 20, 16, 28),
      child: Row(
        spacing: 12,
        children: [
          const CircleAvatar(
            backgroundColor: turquesa,
            child: Icon(Icons.check_rounded, color: turquesaTexto),
          ),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Boa! +1 ponto',
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: turquesaEscuro,
                  ),
                ),
                Text(
                  'Bico fechado e time esperto.',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: turquesaEscuro,
                  ),
                ),
              ],
            ),
          ),
          const Psiu(
            feliz: true,
            tamanho: 72,
          ).animate().scale(duration: 300.ms, curve: Curves.elasticOut),
        ],
      ),
    ).animate().slideY(begin: 1, duration: 220.ms, curve: Curves.easeOutCubic);
  }
}
