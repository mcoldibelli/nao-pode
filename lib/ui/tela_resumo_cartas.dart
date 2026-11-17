import 'package:flutter/material.dart';

import '../domain/partida.dart';
import 'tela_placar.dart';

class TelaResumoCartas extends StatelessWidget {
  const TelaResumoCartas({super.key, required this.partida});

  final Partida partida;

  void _continuar(BuildContext context) {
    partida.encerrarTurno();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => TelaPlacar(partida: partida)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jogadas = partida.jogadasDoTurno;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Cartas de ${partida.timeDaVez.nome}'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: jogadas.isEmpty
                  ? const Center(child: Text('Nenhuma carta jogada.'))
                  : ListView.builder(
                      itemCount: jogadas.length,
                      itemBuilder: (context, i) => ListTile(
                        title: Text(jogadas[i].carta.palavra),
                        trailing: Text(jogadas[i].resultado.name),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _continuar(context),
                  child: const Text('Continuar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
