import 'package:flutter/material.dart';

import '../data/autenticacao.dart';

final modoDoTema = ValueNotifier(ThemeMode.system);

class TelaAjustes extends StatelessWidget {
  const TelaAjustes({super.key, this.sair = sairDoFirebase});

  final Sair sair;

  void _sair(BuildContext context) {
    Navigator.popUntil(context, (rota) => rota.isFirst);
    sair();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Tema', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ValueListenableBuilder(
            valueListenable: modoDoTema,
            builder: (context, modo, _) => SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.system, label: Text('Sistema')),
                ButtonSegment(value: ThemeMode.light, label: Text('Claro')),
                ButtonSegment(value: ThemeMode.dark, label: Text('Escuro')),
              ],
              selected: {modo},
              onSelectionChanged: (escolha) => modoDoTema.value = escolha.first,
            ),
          ),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: () => _sair(context),
            icon: const Icon(Icons.logout),
            label: const Text('Sair da conta'),
          ),
        ],
      ),
    );
  }
}
