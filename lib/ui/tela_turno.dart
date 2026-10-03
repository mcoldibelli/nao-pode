import 'dart:async';

import 'package:flutter/material.dart';

import '../domain/loja.dart';
import '../domain/partida.dart';
import '../domain/resultado.dart';
import 'tela_resumo_cartas.dart';

class TelaTurno extends StatefulWidget {
  const TelaTurno({super.key, required this.partida, required this.loja});

  final Partida partida;
  final Loja loja;

  @override
  State<TelaTurno> createState() => _TelaTurnoState();
}

class _TelaTurnoState extends State<TelaTurno> {
  late int _segundosRestantes = widget.partida.config.segundosPorTurno;
  late final Timer _relogio;

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
    super.dispose();
  }

  void _passarSegundo() {
    if (_segundosRestantes > 1) {
      setState(() => _segundosRestantes--);
      return;
    }
    _relogio.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            TelaResumoCartas(partida: widget.partida, loja: widget.loja),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final partida = widget.partida;
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('${partida.timeDaVez.nome}: $_segundosRestantes s'),
        ),
        body: SafeArea(
          child: ListenableBuilder(
            listenable: partida,
            builder: (context, _) {
              final carta = partida.cartaAtual;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Pontos do time: ${partida.timeDaVez.pontos}',
                      textAlign: TextAlign.center,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 8,
                        children: [
                          Text(
                            carta.palavra,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 16),
                          const Text('Não pode:'),
                          for (final proibida in carta.proibidas)
                            Text(proibida),
                        ],
                      ),
                    ),
                    Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                partida.registrar(Resultado.acertou),
                            child: const Text('Acertou'),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => partida.registrar(Resultado.errou),
                            child: const Text('Errou'),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: partida.pulosRestantes > 0
                          ? () => partida.registrar(Resultado.pulou)
                          : null,
                      child: Text('Pular (${partida.pulosRestantes})'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
